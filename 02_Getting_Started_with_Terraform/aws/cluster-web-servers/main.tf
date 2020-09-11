locals {
  service = "cluster-web-servers"

  ami           = "ami-0e2512bd9da751ea8" // ubuntu 20.04 LTS
  instance_type = "t3.nano"
}

terraform {
  required_version = ">= 0.12, < 0.13"
}

provider "aws" {
  region  = "us-east-1"
  version = "~> 3.0"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_launch_configuration" "this" {
  image_id        = local.ami
  instance_type   = local.instance_type
  security_groups = [aws_security_group.this.id]

  user_data = <<-EOF
            #!/bin/bash
            echo "Hello, World" > index.html
            nohup busybox httpd -f -p "${var.server_port}" &
            EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  launch_configuration = aws_launch_configuration.this.name
  vpc_zone_identifier  = data.aws_subnet_ids.default.ids

  target_group_arns = [aws_lb_target_group.http.arn]
  health_check_type = "ELB"

  min_size = 2
  max_size = 10

  tag {
    key                 = "Name"
    value               = "${local.service}-asg"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "this" {
  name        = "${local.service}-sg"
  description = "Allows HTTP traffic on port ${var.server_port} from the LB"

  ingress {
    from_port       = var.server_port
    to_port         = var.server_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name    = "${local.service}-sg"
    service = local.service
  }
}

resource "aws_lb" "http" {
  name = "${local.service}-alb"

  load_balancer_type = "application"
  subnets            = data.aws_subnet_ids.default.ids
  security_groups    = [aws_security_group.alb.id]

  tags = {
    Name    = "${local.service}-alb"
    service = local.service
  }
}

resource "aws_lb_target_group" "http" {
  name = "${local.service}-tg"

  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name    = "${local.service}-tg"
    service = local.service
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.http.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_listener_rule" "http" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }
}

resource "aws_security_group" "alb" {
  name        = "${local.service}-alb-sg"
  description = "Allows HTTP traffic on port 80 from all sources"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${local.service}-alb-sg"
    service = local.service
  }
}
