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

* [Complete](https://github.com/terraform-aws-modules/terraform-aws-step-functions/tree/master/examples/complete) - Create Step Function and required IAM resources in various combinations with all supported features.


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.6 |
| aws | >= 3.27 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.27 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| attach\_policies | Controls whether list of policies should be added to IAM role | `bool` | `false` | no |
| attach\_policies\_for\_integrations | Whether to attach AWS Service policies to IAM role | `bool` | `true` | no |
| attach\_policy | Controls whether policy should be added to IAM role | `bool` | `false` | no |
| attach\_policy\_json | Controls whether policy\_json should be added to IAM role | `bool` | `false` | no |
| attach\_policy\_jsons | Controls whether policy\_jsons should be added to IAM role | `bool` | `false` | no |
| attach\_policy\_statements | Controls whether policy\_statements should be added to IAM role | `bool` | `false` | no |
| aws\_region\_assume\_role | Name of AWS regions where IAM role can be assumed by the Step Function | `string` | `""` | no |
| create | Whether to create Step Function resource | `bool` | `true` | no |
| create\_role | Whether to create IAM role for the Step Function | `bool` | `true` | no |
| definition | The Amazon States Language definition of the Step Function | `string` | `""` | no |
| name | The name of the Step Function | `string` | `""` | no |
| number\_of\_policies | Number of policies to attach to IAM role | `number` | `0` | no |
| number\_of\_policy\_jsons | Number of policies JSON to attach to IAM role | `number` | `0` | no |
| policies | List of policy statements ARN to attach to IAM role | `list(string)` | `[]` | no |
| policy | An additional policy document ARN to attach to IAM role | `string` | `null` | no |
| policy\_json | An additional policy document as JSON to attach to IAM role | `string` | `null` | no |
| policy\_jsons | List of additional policy documents as JSON to attach to IAM role | `list(string)` | `[]` | no |
| policy\_statements | Map of dynamic policy statements to attach to IAM role | `any` | `{}` | no |
| role\_arn | The Amazon Resource Name (ARN) of the IAM role to use for this Step Function | `string` | `""` | no |
| role\_description | Description of IAM role to use for Step Function | `string` | `null` | no |
| role\_force\_detach\_policies | Specifies to force detaching any policies the IAM role has before destroying it. | `bool` | `true` | no |
| role\_name | Name of IAM role to use for Step Function | `string` | `null` | no |
| role\_path | Path of IAM role to use for Step Function | `string` | `null` | no |
| role\_permissions\_boundary | The ARN of the policy that is used to set the permissions boundary for the IAM role used by Step Function | `string` | `null` | no |
| role\_tags | A map of tags to assign to IAM role | `map(string)` | `{}` | no |
| service\_integrations | Map of AWS service integrations to allow in IAM role policy | `any` | `{}` | no |
| tags | Maps of tags to assign to the Step Function | `map(string)` | `{}` | no |
| trusted\_entities | Step Function additional trusted entities for assuming roles (trust relationship) | `list(string)` | `[]` | no |
| type | Determines whether a Standard or Express state machine is created. The default is STANDARD. Valid Values: STANDARD \| EXPRESS | `string` | `"STANDARD"` | no |
| use\_existing\_role | Whether to use an existing IAM role for this Step Function | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| this\_role\_arn | The ARN of the IAM role created for the Step Function |
| this\_role\_name | The name of the IAM role created for the Step Function |
| this\_state\_machine\_arn | The ARN of the Step Function |
| this\_state\_machine\_creation\_date | The date the Step Function was created |
| this\_state\_machine\_id | The ARN of the Step Function |
| this\_state\_machine\_status | The current status of the Step Function |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Anton Babenko](https://github.com/antonbabenko). Check out [serverless.tf](https://serverless.tf) to learn more about doing serverless with Terraform.

Please reach out to [Betajob](https://www.betajob.com/) if you are looking for commercial support for your Terraform, AWS, or serverless project.


## License

Apache 2 Licensed. See LICENSE for full details.
