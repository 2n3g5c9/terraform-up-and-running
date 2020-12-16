<div align="center">
  <img width="512" src="https://raw.githubusercontent.com/2n3g5c9/terraform-up-and-running/master/img/banner.png" alt="terraform-up-and-running">
</div>

<br />

<div align="center">AWS & GCP examples from "Terraform: Up and Running" published by O'Reilly, adapted for v0.14</div>

<br />

## Code quick access

[Chapter 2 - Getting Started with Terraform](./02_Getting_Started_with_Terraform)

[Chapter 3 - How to Manage Terraform State](./03_How_to_Manage_Terraform_State)

[Chapter 4 - How to Create Reusable Infrastructure with Terraform Modules](./04_How_to_Create_Reusable_Infrastructure_with_Terraform_Modules)

[Chapter 5 - Terraform Tips and Tricks](./05_Terraform_Tips_and_Tricks)

## Prerequisites

### Amazon Web Services
To run the AWS related examples in this repository, you need to have your AWS credentials accessible locally, either in `~/.aws`, or via environment variables. You can also use [aws-vault](https://github.com/99designs/aws-vault) to generate temporary crendentials.

### Google Cloud Platform
To run the GCP related examples in the repository, you need to have a valid GCP keyfile for a service account with the right level of permissions. Specify the path to that keyfile via the environment variable `GOOGLE_APPLICATION_CREDENTIALS`:

```bash
export GOOGLE_APPLICATION_CREDENTIALS="[PATH]"
```

## How to use

To initialize the working directory:

```bash
terraform init
```

To preview incoming changes to the infrastructure, run the following command:

```bash
terraform plan -out terraform.tfplan
```

To provision the planned infrastructure, simply apply the Terraform configuration:

```bash
terraform apply terraform.tfplan
```

To destroy the provisioned infrastructure, run the following command:

```bash
terraform destroy
```

## Tech/frameworks used

- [Terraform](https://www.terraform.io/): A tool to "Write, Plan, and Create Infrastructure as Code".

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
