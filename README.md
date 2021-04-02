# AWS Step Functions Terraform module

Terraform module, which creates AWS Step Functions as well as required IAM role and IAM policies for [Integrated Services](https://docs.aws.amazon.com/step-functions/latest/dg/service-integration-iam-templates.html).

This Terraform module is the part of [serverless.tf framework](https://github.com/antonbabenko/serverless.tf), which aims to simplify all operations when working with the serverless in Terraform.

## Features

- [x] Creates AWS Step Function
- [x] Conditional creation for many types of resources
- [x] Support IAM policy attachments for [Integrated Services (eg, Lambda, SQS, ECS, EKS, Batch, DynamoDB, etc)](https://docs.aws.amazon.com/step-functions/latest/dg/service-integration-iam-templates.html) and various ways to create and attach additional policies

## Usage

### Step Function

```hcl
module "step_function" {
  source = "terraform-aws-modules/step-functions/aws"

  name       = "my-step-function"
  definition = <<EOF
{
  "Comment": "A Hello World example of the Amazon States Language using Pass states",
  "StartAt": "Hello",
  "States": {
    "Hello": {
      "Type": "Pass",
      "Result": "Hello",
      "Next": "World"
    },
    "World": {
      "Type": "Pass",
      "Result": "World",
      "End": true
    }
  }
}
EOF

  service_integrations = {
    dynamodb = {
      dynamodb = ["arn:aws:dynamodb:eu-west-1:052212379155:table/Test"]
    }

    lambda = {
      lambda = ["arn:aws:lambda:eu-west-1:123456789012:function:test1", "arn:aws:lambda:eu-west-1:123456789012:function:test2"]
    }
  }

  type = "STANDARD"

  tags = {
    Module = "my"
  }
}
```

## Service integration policies

There are predefined policies for all available integrations (see `aws_service_policies` in `locals.tf` for values) which can be used as a key inside `service_integrations` argument.

Each key of `aws_service_policies` contains configuration for the IAM policy statements which will be combined with the values specified in `service_integrations` argument.

Example of `service_integrations` arguments:

```hcl
module "step_function" {
  source = "terraform-aws-modules/step-functions/aws"

  # ... omitted
  service_integrations = {
    xray = {
      xray = true  # the value of default_resources key will be used when key value is `true`
    }

    sqs = {
      sqs = "arn:aws:sqs:..."  # sqs queue ARN is required because there is no default_resources key for such integration
    }

    # Special case to deny all actions for the step function (this will override all IAM policies allowed for the function)
    no_tasks = {
      deny_all = true
    }
  }
}
```

## Additional IAM policies for Step Function

In addition to all supported AWS service integrations you may want to create and attach additional policies.

There are 5 supported ways to attach additional IAM policies to IAM role used by Step Function:

1. `policy_json` - JSON string or heredoc, when `attach_policy_json = true`.
1. `policy_jsons` - List of JSON strings or heredoc, when `attach_policy_jsons = true` and `number_of_policy_jsons > 0`.
1. `policy` - ARN of existing IAM policy, when `attach_policy = true`.
1. `policies` - List of ARNs of existing IAM policies, when `attach_policies = true` and `number_of_policies > 0`.
1. `policy_statements` - Map of maps to define IAM statements which will be generated as IAM policy. Requires `attach_policy_statements = true`. See `examples/complete` for more information.

## Conditional creation

Sometimes you need to have a way to create resources conditionally, so the solution is to specify `create` arguments.

```hcl
module "step_function" {
  source = "terraform-aws-modules/step-functions/aws"

  create      = false # to disable all resources
  create_role = false  # to control creation of the IAM role and policies required for Step Function

  # ... omitted
}
```

## Examples

- [Complete](https://github.com/terraform-aws-modules/terraform-aws-step-functions/tree/master/examples/complete) - Create Step Function and required IAM resources in various combinations with all supported features.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

| Name                                                                     | Version   |
| ------------------------------------------------------------------------ | --------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | >= 3.27   |

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | >= 3.27 |

## Modules

No modules.

## Resources

| Name                                                                                                                                                     | Type        |
| -------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_iam_policy.additional_inline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                               | resource    |
| [aws_iam_policy.additional_json](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                                 | resource    |
| [aws_iam_policy.additional_jsons](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                                | resource    |
| [aws_iam_policy.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                                         | resource    |
| [aws_iam_policy_attachment.additional_inline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment)         | resource    |
| [aws_iam_policy_attachment.additional_json](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment)           | resource    |
| [aws_iam_policy_attachment.additional_jsons](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment)          | resource    |
| [aws_iam_policy_attachment.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment)                   | resource    |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                                | resource    |
| [aws_iam_role_policy_attachment.additional_many](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource    |
| [aws_iam_role_policy_attachment.additional_one](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)  | resource    |
| [aws_sfn_state_machine.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sfn_state_machine)                              | resource    |
| [aws_iam_policy_document.additional_inline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)          | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)                | data source |
| [aws_iam_policy_document.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)                    | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region)                                              | data source |

## Inputs

| Name                                                                                                                              | Description                                                                                                                   | Type           | Default      | Required |
| --------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- | -------------- | ------------ | :------: |
| <a name="input_attach_policies"></a> [attach_policies](#input_attach_policies)                                                    | Controls whether list of policies should be added to IAM role                                                                 | `bool`         | `false`      |    no    |
| <a name="input_attach_policies_for_integrations"></a> [attach_policies_for_integrations](#input_attach_policies_for_integrations) | Whether to attach AWS Service policies to IAM role                                                                            | `bool`         | `true`       |    no    |
| <a name="input_attach_policy"></a> [attach_policy](#input_attach_policy)                                                          | Controls whether policy should be added to IAM role                                                                           | `bool`         | `false`      |    no    |
| <a name="input_attach_policy_json"></a> [attach_policy_json](#input_attach_policy_json)                                           | Controls whether policy_json should be added to IAM role                                                                      | `bool`         | `false`      |    no    |
| <a name="input_attach_policy_jsons"></a> [attach_policy_jsons](#input_attach_policy_jsons)                                        | Controls whether policy_jsons should be added to IAM role                                                                     | `bool`         | `false`      |    no    |
| <a name="input_attach_policy_statements"></a> [attach_policy_statements](#input_attach_policy_statements)                         | Controls whether policy_statements should be added to IAM role                                                                | `bool`         | `false`      |    no    |
| <a name="input_aws_region_assume_role"></a> [aws_region_assume_role](#input_aws_region_assume_role)                               | Name of AWS regions where IAM role can be assumed by the Step Function                                                        | `string`       | `""`         |    no    |
| <a name="input_create"></a> [create](#input_create)                                                                               | Whether to create Step Function resource                                                                                      | `bool`         | `true`       |    no    |
| <a name="input_create_role"></a> [create_role](#input_create_role)                                                                | Whether to create IAM role for the Step Function                                                                              | `bool`         | `true`       |    no    |
| <a name="input_definition"></a> [definition](#input_definition)                                                                   | The Amazon States Language definition of the Step Function                                                                    | `string`       | `""`         |    no    |
| <a name="input_name"></a> [name](#input_name)                                                                                     | The name of the Step Function                                                                                                 | `string`       | `""`         |    no    |
| <a name="input_number_of_policies"></a> [number_of_policies](#input_number_of_policies)                                           | Number of policies to attach to IAM role                                                                                      | `number`       | `0`          |    no    |
| <a name="input_number_of_policy_jsons"></a> [number_of_policy_jsons](#input_number_of_policy_jsons)                               | Number of policies JSON to attach to IAM role                                                                                 | `number`       | `0`          |    no    |
| <a name="input_policies"></a> [policies](#input_policies)                                                                         | List of policy statements ARN to attach to IAM role                                                                           | `list(string)` | `[]`         |    no    |
| <a name="input_policy"></a> [policy](#input_policy)                                                                               | An additional policy document ARN to attach to IAM role                                                                       | `string`       | `null`       |    no    |
| <a name="input_policy_json"></a> [policy_json](#input_policy_json)                                                                | An additional policy document as JSON to attach to IAM role                                                                   | `string`       | `null`       |    no    |
| <a name="input_policy_jsons"></a> [policy_jsons](#input_policy_jsons)                                                             | List of additional policy documents as JSON to attach to IAM role                                                             | `list(string)` | `[]`         |    no    |
| <a name="input_policy_statements"></a> [policy_statements](#input_policy_statements)                                              | Map of dynamic policy statements to attach to IAM role                                                                        | `any`          | `{}`         |    no    |
| <a name="input_role_arn"></a> [role_arn](#input_role_arn)                                                                         | The Amazon Resource Name (ARN) of the IAM role to use for this Step Function                                                  | `string`       | `""`         |    no    |
| <a name="input_role_description"></a> [role_description](#input_role_description)                                                 | Description of IAM role to use for Step Function                                                                              | `string`       | `null`       |    no    |
| <a name="input_role_force_detach_policies"></a> [role_force_detach_policies](#input_role_force_detach_policies)                   | Specifies to force detaching any policies the IAM role has before destroying it.                                              | `bool`         | `true`       |    no    |
| <a name="input_role_name"></a> [role_name](#input_role_name)                                                                      | Name of IAM role to use for Step Function                                                                                     | `string`       | `null`       |    no    |
| <a name="input_role_path"></a> [role_path](#input_role_path)                                                                      | Path of IAM role to use for Step Function                                                                                     | `string`       | `null`       |    no    |
| <a name="input_role_permissions_boundary"></a> [role_permissions_boundary](#input_role_permissions_boundary)                      | The ARN of the policy that is used to set the permissions boundary for the IAM role used by Step Function                     | `string`       | `null`       |    no    |
| <a name="input_role_tags"></a> [role_tags](#input_role_tags)                                                                      | A map of tags to assign to IAM role                                                                                           | `map(string)`  | `{}`         |    no    |
| <a name="input_service_integrations"></a> [service_integrations](#input_service_integrations)                                     | Map of AWS service integrations to allow in IAM role policy                                                                   | `any`          | `{}`         |    no    |
| <a name="input_tags"></a> [tags](#input_tags)                                                                                     | Maps of tags to assign to the Step Function                                                                                   | `map(string)`  | `{}`         |    no    |
| <a name="input_trusted_entities"></a> [trusted_entities](#input_trusted_entities)                                                 | Step Function additional trusted entities for assuming roles (trust relationship)                                             | `list(string)` | `[]`         |    no    |
| <a name="input_type"></a> [type](#input_type)                                                                                     | Determines whether a Standard or Express state machine is created. The default is STANDARD. Valid Values: STANDARD \| EXPRESS | `string`       | `"STANDARD"` |    no    |
| <a name="input_use_existing_role"></a> [use_existing_role](#input_use_existing_role)                                              | Whether to use an existing IAM role for this Step Function                                                                    | `bool`         | `false`      |    no    |

## Outputs

| Name                                                                                                                                | Description                                            |
| ----------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------ |
| <a name="output_this_role_arn"></a> [this_role_arn](#output_this_role_arn)                                                          | The ARN of the IAM role created for the Step Function  |
| <a name="output_this_role_name"></a> [this_role_name](#output_this_role_name)                                                       | The name of the IAM role created for the Step Function |
| <a name="output_this_state_machine_arn"></a> [this_state_machine_arn](#output_this_state_machine_arn)                               | The ARN of the Step Function                           |
| <a name="output_this_state_machine_creation_date"></a> [this_state_machine_creation_date](#output_this_state_machine_creation_date) | The date the Step Function was created                 |
| <a name="output_this_state_machine_id"></a> [this_state_machine_id](#output_this_state_machine_id)                                  | The ARN of the Step Function                           |
| <a name="output_this_state_machine_status"></a> [this_state_machine_status](#output_this_state_machine_status)                      | The current status of the Step Function                |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Anton Babenko](https://github.com/antonbabenko). Check out [serverless.tf](https://serverless.tf) to learn more about doing serverless with Terraform.

Please reach out to [Betajob](https://www.betajob.com/) if you are looking for commercial support for your Terraform, AWS, or serverless project.

## License

Apache 2 Licensed. See LICENSE for full details.
