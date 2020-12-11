<div align="center">
  <img width="512" src="https://raw.githubusercontent.com/2n3g5c9/terraform-up-and-running/master/img/terraform-up-and-running_banner.png" alt="terraform-up-and-running">
</div>

<br />

<div align="center">AWS & GCP examples from "Terraform: Up and Running" published by O'Reilly, updated for 0.14</div>

<br />

## Prerequisites

### Amazon Web Services
To run the AWS related examples in this repository, you need to have your AWS user credentials accessible locally, either in `~/.aws`, or via environment variables. 

### Google Cloud Platform
To run the GCP related examples in the repository, you need to have a valid GCP keyfile for a service account with the right level of permissions. Specify the path to that keyfile via the environment variable `GOOGLE_CLOUD_KEYFILE_JSON`:

```bash
export GOOGLE_CLOUD_KEYFILE_JSON=./keyfile.json
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

To provision the infrastructure, simply apply the Terraform configuration:

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