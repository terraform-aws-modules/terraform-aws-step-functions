# Complete AWS Step Function example

Configuration in this directory creates AWS Step Function and IAM role with large variety of supported AWS Service integrations and custom policies.

Note: You probably don't need to set custom/additional policies but use `service_integrations` only.


## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.6 |
| aws | >= 3.27 |
| random | >= 2 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.27 |
| random | >= 2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| disabled_step_function | ../../ |  |
| step_function | ../../ |  |

## Resources

| Name |
|------|
| [aws_sqs_queue](https://registry.terraform.io/providers/hashicorp/aws/3.27/docs/resources/sqs_queue) |
| [random_pet](https://registry.terraform.io/providers/hashicorp/random/2/docs/resources/pet) |

## Inputs

No input.

## Outputs

| Name | Description |
|------|-------------|
| this\_role\_arn | The ARN of the IAM role created for the State Machine |
| this\_role\_name | The name of the IAM role created for the State Machine |
| this\_state\_machine\_arn | The ARN of the State Machine |
| this\_state\_machine\_creation\_date | The date the State Machine was created |
| this\_state\_machine\_id | The ARN of the State Machine |
| this\_state\_machine\_status | The current status of the State Machine |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
