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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.61 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.61 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 2 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_disabled_step_function"></a> [disabled\_step\_function](#module\_disabled\_step\_function) | ../../ | n/a |
| <a name="module_kms"></a> [kms](#module\_kms) | terraform-aws-modules/kms/aws | ~> 1.0 |
| <a name="module_lambda_function"></a> [lambda\_function](#module\_lambda\_function) | terraform-aws-modules/lambda/aws | ~> 2.0 |
| <a name="module_step_function"></a> [step\_function](#module\_step\_function) | ../../ | n/a |
| <a name="module_step_function_with_existing_log_group"></a> [step\_function\_with\_existing\_log\_group](#module\_step\_function\_with\_existing\_log\_group) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.external](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_sqs_queue.queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [null_resource.download_package](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_pet.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_log_group_arn"></a> [cloudwatch\_log\_group\_arn](#output\_cloudwatch\_log\_group\_arn) | The ARN of the CloudWatch log group created for the Step Function |
| <a name="output_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#output\_cloudwatch\_log\_group\_name) | The name of the CloudWatch log group created for the Step Function |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | The ARN of the IAM role created for the State Machine |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | The name of the IAM role created for the State Machine |
| <a name="output_state_machine_arn"></a> [state\_machine\_arn](#output\_state\_machine\_arn) | The ARN of the State Machine |
| <a name="output_state_machine_creation_date"></a> [state\_machine\_creation\_date](#output\_state\_machine\_creation\_date) | The date the State Machine was created |
| <a name="output_state_machine_id"></a> [state\_machine\_id](#output\_state\_machine\_id) | The ARN of the State Machine |
| <a name="output_state_machine_status"></a> [state\_machine\_status](#output\_state\_machine\_status) | The current status of the State Machine |
| <a name="output_state_machine_version_arn"></a> [state\_machine\_version\_arn](#output\_state\_machine\_version\_arn) | The ARN of state machine version |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
