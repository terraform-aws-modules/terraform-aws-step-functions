provider "aws" {
  region = "eu-west-1"

  # Make it faster by skipping something
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  name = "ex-${basename(path.cwd)}"

  definition_template = <<EOF
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

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-step-functions"
    GithubOrg  = "terraform-aws-modules"
  }
}

module "step_function" {
  source = "../../"

  name = random_pet.this.id

  type = "express"

  definition = local.definition_template
  publish    = true

  encryption_configuration = {
    type                              = "CUSTOMER_MANAGED_KMS_KEY"
    kms_key_id                        = module.kms.key_arn
    kms_data_key_reuse_period_seconds = 600
  }

  logging_configuration = {
    include_execution_data = true
    level                  = "ALL"
  }

  service_integrations = {

    batch_Sync = {
      events = true
    }

    dynamodb = {
      dynamodb = ["arn:aws:dynamodb:eu-west-1:052212379155:table/Test"]
    }

    athena_StartQueryExecution_Sync = {
      athena        = ["arn:aws:athena:eu-west-1:123456789012:something1:test1"]
      glue          = ["arn:aws:glue:eu-west-1:123456789012:something2:test1"]
      s3            = true # options: true (use default value from `aws_service_policies`) or provide a list of ARNs
      lakeformation = ["arn:aws:lakeformation:eu-west-1:123456789012:something3:test1"]
    }

    lambda = {
      lambda = [
      module.lambda_function.lambda_function_arn, "arn:aws:lambda:eu-west-1:123456789012:function:test2"]
    }

    xray = {
      xray = true
    }

    stepfunction_Sync = {
      stepfunction          = ["arn:aws:states:eu-west-1:123456789012:stateMachine:test1"]
      stepfunction_Wildcard = ["arn:aws:states:eu-west-1:123456789012:stateMachine:test1"]

      # Set to true to use the default events (otherwise, set this to a list of ARNs; see the docs linked in locals.tf
      # for more information). Without events permissions, you will get an error similar to this:
      #   Error: AccessDeniedException: 'arn:aws:iam::xxxx:role/step-functions-role' is not authorized to
      #   create managed-rule
      events = true
    }

    #    # NB: This will "Deny" everything (including logging)!
    #    no_tasks = {
    #      deny_all = true
    #    }
  }

  ######################
  # Additional policies
  # Probably you are not going to need them (use `service_integrations` instead)!
  ######################

  attach_policy_json = true
  policy_json        = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "xray:GetSamplingStatisticSummaries"
            ],
            "Resource": ["*"]
        }
    ]
}
EOF

  attach_policy_jsons = true
  policy_jsons = [<<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "xray:*"
            ],
            "Resource": ["*"]
        }
    ]
}
EOF
  ]
  number_of_policy_jsons = 1

  attach_policy = true
  policy        = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"

  attach_policies    = true
  policies           = ["arn:aws:iam::aws:policy/AWSXrayReadOnlyAccess"]
  number_of_policies = 1

  attach_policy_statements = true
  policy_statements = {
    dynamodb = {
      effect    = "Allow",
      actions   = ["dynamodb:BatchWriteItem"],
      resources = ["arn:aws:dynamodb:eu-west-1:052212379155:table/Test"]
    },
    s3_read = {
      effect    = "Deny",
      actions   = ["s3:HeadObject", "s3:GetObject"],
      resources = ["arn:aws:s3:::my-bucket/*"]
    }
    kms = {
      effect    = "Allow"
      actions   = ["kms:Decrypt", "kms:GenerateDataKey"]
      resources = [module.kms.key_arn]
      condition = [{
        test     = "StringEquals"
        variable = "kms:EncryptionContext:aws:states:stateMachineArn"
        values   = ["arn:aws:states:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:stateMachine:${random_pet.this.id}"]
      }]
    }
  }

  ###########################
  # END: Additional policies
  ###########################

  sfn_state_machine_timeouts = {
    create = "30m"
    delete = "50m"
    update = "30m"
  }

  tags = merge(local.tags, {
    Module = "step_function"
  })
}

###############################################
# With CloudWatch log group created externally
###############################################

resource "aws_cloudwatch_log_group" "external" {
  name = "${random_pet.this.id}-my-log-group"

  tags = local.tags
}

module "step_function_with_existing_log_group" {
  source = "../../"

  name = "${random_pet.this.id}-existing-log-group"

  type = "express"

  definition = local.definition_template

  use_existing_cloudwatch_log_group = true
  cloudwatch_log_group_name         = aws_cloudwatch_log_group.external.name

  logging_configuration = {
    include_execution_data = false
    level                  = "ERROR"
  }

  tags = local.tags

  depends_on = [aws_cloudwatch_log_group.external]
}

#############################################
# Using packaged function from Lambda module
#############################################

locals {
  package_url = "https://raw.githubusercontent.com/terraform-aws-modules/terraform-aws-lambda/master/examples/fixtures/python3.8-zip/existing_package.zip"
  downloaded  = "downloaded_package_${md5(local.package_url)}.zip"
}

resource "null_resource" "download_package" {
  triggers = {
    downloaded = local.downloaded
  }

  provisioner "local-exec" {
    command = "curl -L -o ${local.downloaded} ${local.package_url}"
  }
}

module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 8.0"

  function_name = "${random_pet.this.id}-lambda"
  description   = "My awesome lambda function"
  handler       = "index.lambda_handler"
  runtime       = "python3.12"

  publish = true

  create_package         = false
  local_existing_package = local.downloaded

  tags = local.tags
}

###########
# Disabled
###########

module "disabled_step_function" {
  source = "../../"

  create = false
}

##################
# Extra resources
##################

resource "random_pet" "this" {
  length = 2
}

resource "aws_sqs_queue" "queue" {
  name = random_pet.this.id

  tags = local.tags
}

module "kms" {
  source      = "terraform-aws-modules/kms/aws"
  version     = "~> 1.0"
  description = "KMS key for step functions"

  # Aliases
  aliases                 = [local.name]
  aliases_use_name_prefix = true

  key_owners = [data.aws_caller_identity.current.arn]

  tags = local.tags
}
