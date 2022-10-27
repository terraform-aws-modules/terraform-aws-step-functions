locals {
  create_role = var.create && var.create_role && !var.use_existing_role
  aws_region  = local.create_role && var.aws_region_assume_role == "" ? data.aws_region.current[0].name : var.aws_region_assume_role

  enable_logging = try(var.logging_configuration["level"], "OFF") != "OFF"

  enable_xray_tracing = try(var.service_integrations["xray"]["xray"], false) == true

  # Normalize ARN by trimming ":*" because data-source has it, but resource does not have it
  log_group_arn = trimsuffix(try(data.aws_cloudwatch_log_group.sfn[0].arn, aws_cloudwatch_log_group.sfn[0].arn, ""), ":*")

  role_name = local.create_role ? coalesce(var.role_name, var.name) : null
}

resource "aws_sfn_state_machine" "this" {
  count = var.create ? 1 : 0

  name = var.name

  role_arn   = var.use_existing_role ? var.role_arn : aws_iam_role.this[0].arn
  definition = var.definition

  dynamic "logging_configuration" {
    for_each = local.enable_logging ? [true] : []

    content {
      log_destination        = lookup(var.logging_configuration, "log_destination", "${local.log_group_arn}:*")
      include_execution_data = lookup(var.logging_configuration, "include_execution_data", null)
      level                  = lookup(var.logging_configuration, "level", null)
    }
  }

  dynamic "tracing_configuration" {
    for_each = local.enable_xray_tracing ? [true] : []
    content {
      enabled = true
    }
  }

  type = upper(var.type)

  tags = merge({ Name = var.name }, var.tags)
}

###########
# IAM Role
###########

data "aws_region" "current" {
  count = local.create_role && var.aws_region_assume_role == "" ? 1 : 0
}

data "aws_iam_policy_document" "assume_role" {
  count = local.create_role ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = distinct(concat(["states.${local.aws_region}.amazonaws.com"], var.trusted_entities))
    }
  }
}

resource "aws_iam_role" "this" {
  count = local.create_role ? 1 : 0

  name                  = local.role_name
  description           = var.role_description
  path                  = var.role_path
  force_detach_policies = var.role_force_detach_policies
  permissions_boundary  = var.role_permissions_boundary
  assume_role_policy    = data.aws_iam_policy_document.assume_role[0].json

  tags = merge(var.tags, var.role_tags)
}

##############################
# Predefined service policies
##############################

data "aws_iam_policy_document" "service" {
  for_each = { for k, v in var.service_integrations : k => v if local.create_role && var.attach_policies_for_integrations }

  dynamic "statement" {
    for_each = each.value

    content {
      effect    = lookup(local.aws_service_policies[each.key][statement.key], "effect", "Allow")
      sid       = replace("${each.key}${title(statement.key)}", "/[^0-9A-Za-z]*/", "")
      actions   = local.aws_service_policies[each.key][statement.key]["actions"]
      resources = statement.value == true ? local.aws_service_policies[each.key][statement.key]["default_resources"] : tolist(statement.value)

      dynamic "condition" {
        for_each = lookup(local.aws_service_policies[each.key][statement.key], "condition", [])
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

resource "aws_iam_policy" "service" {
  for_each = { for k, v in var.service_integrations : k => v if local.create_role && var.attach_policies_for_integrations }

  name   = "${local.role_name}-${each.key}"
  policy = data.aws_iam_policy_document.service[each.key].json
  tags   = var.tags
}

resource "aws_iam_policy_attachment" "service" {
  for_each = { for k, v in var.service_integrations : k => v if local.create_role && var.attach_policies_for_integrations }

  name       = "${local.role_name}-${each.key}"
  roles      = [aws_iam_role.this[0].name]
  policy_arn = aws_iam_policy.service[each.key].arn
}


###########################
# Additional policy (JSON)
###########################

resource "aws_iam_policy" "additional_json" {
  count = local.create_role && var.attach_policy_json ? 1 : 0

  name   = local.role_name
  policy = var.policy_json
  tags   = var.tags
}

resource "aws_iam_policy_attachment" "additional_json" {
  count = local.create_role && var.attach_policy_json ? 1 : 0

  name       = local.role_name
  roles      = [aws_iam_role.this[0].name]
  policy_arn = aws_iam_policy.additional_json[0].arn
}

#####################################
# Additional policies (list of JSON)
#####################################

resource "aws_iam_policy" "additional_jsons" {
  count = local.create_role && var.attach_policy_jsons ? var.number_of_policy_jsons : 0

  name   = "${local.role_name}-${count.index}"
  policy = var.policy_jsons[count.index]
  tags   = var.tags
}

resource "aws_iam_policy_attachment" "additional_jsons" {
  count = local.create_role && var.attach_policy_jsons ? var.number_of_policy_jsons : 0

  name       = "${local.role_name}-${count.index}"
  roles      = [aws_iam_role.this[0].name]
  policy_arn = aws_iam_policy.additional_jsons[count.index].arn
}

###########################
# ARN of additional policy
###########################

resource "aws_iam_role_policy_attachment" "additional_one" {
  count = local.create_role && var.attach_policy ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = var.policy
}

######################################
# List of ARNs of additional policies
######################################

resource "aws_iam_role_policy_attachment" "additional_many" {
  count = local.create_role && var.attach_policies ? var.number_of_policies : 0

  role       = aws_iam_role.this[0].name
  policy_arn = var.policies[count.index]
}

###############################
# Additional policy statements
###############################

data "aws_iam_policy_document" "additional_inline" {
  count = local.create_role && var.attach_policy_statements ? 1 : 0

  dynamic "statement" {
    for_each = var.policy_statements

    content {
      sid           = lookup(statement.value, "sid", replace(statement.key, "/[^0-9A-Za-z]*/", ""))
      effect        = lookup(statement.value, "effect", null)
      actions       = lookup(statement.value, "actions", null)
      not_actions   = lookup(statement.value, "not_actions", null)
      resources     = lookup(statement.value, "resources", null)
      not_resources = lookup(statement.value, "not_resources", null)

      dynamic "principals" {
        for_each = lookup(statement.value, "principals", [])
        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = lookup(statement.value, "not_principals", [])
        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = lookup(statement.value, "condition", [])
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

resource "aws_iam_policy" "additional_inline" {
  count = local.create_role && var.attach_policy_statements ? 1 : 0

  name   = "${local.role_name}-inline"
  policy = data.aws_iam_policy_document.additional_inline[0].json
  tags   = var.tags
}

resource "aws_iam_policy_attachment" "additional_inline" {
  count = local.create_role && var.attach_policy_statements ? 1 : 0

  name       = local.role_name
  roles      = [aws_iam_role.this[0].name]
  policy_arn = aws_iam_policy.additional_inline[0].arn
}

#################################
# IAM policy for Cloudwatch Logs
#################################

data "aws_iam_policy_document" "logs" {
  count = local.create_role && local.enable_logging && var.attach_cloudwatch_logs_policy ? 1 : 0

  # Copied from https://docs.aws.amazon.com/step-functions/latest/dg/cw-logs.html
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogDelivery",
      "logs:GetLogDelivery",
      "logs:UpdateLogDelivery",
      "logs:DeleteLogDelivery",
      "logs:ListLogDeliveries",
      "logs:PutResourcePolicy",
      "logs:DescribeResourcePolicies",
      "logs:DescribeLogGroups",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "logs" {
  count = local.create_role && local.enable_logging && var.attach_cloudwatch_logs_policy ? 1 : 0

  name   = "${local.role_name}-logs"
  policy = data.aws_iam_policy_document.logs[0].json
  tags   = var.tags
}

resource "aws_iam_policy_attachment" "logs" {
  count = local.create_role && local.enable_logging && var.attach_cloudwatch_logs_policy ? 1 : 0

  name       = "${local.role_name}-logs"
  roles      = [aws_iam_role.this[0].name]
  policy_arn = aws_iam_policy.logs[0].arn
}

##################
# CloudWatch Logs
##################

data "aws_cloudwatch_log_group" "sfn" {
  count = var.create && local.enable_logging && var.use_existing_cloudwatch_log_group ? 1 : 0

  name = var.cloudwatch_log_group_name
}

resource "aws_cloudwatch_log_group" "sfn" {
  count = var.create && local.enable_logging && !var.use_existing_cloudwatch_log_group ? 1 : 0

  name              = coalesce(var.cloudwatch_log_group_name, var.name)
  retention_in_days = var.cloudwatch_log_group_retention_in_days
  kms_key_id        = var.cloudwatch_log_group_kms_key_id

  tags = merge(var.tags, var.cloudwatch_log_group_tags)
}
