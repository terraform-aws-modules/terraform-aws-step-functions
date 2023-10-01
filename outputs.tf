# Step Function
output "state_machine_id" {
  description = "The ARN of the Step Function"
  value       = try(aws_sfn_state_machine.this[0].id, "")
}

output "state_machine_arn" {
  description = "The ARN of the Step Function"
  value       = try(aws_sfn_state_machine.this[0].arn, "")
}

output "state_machine_creation_date" {
  description = "The date the Step Function was created"
  value       = try(aws_sfn_state_machine.this[0].creation_date, "")
}

output "state_machine_status" {
  description = "The current status of the Step Function"
  value       = try(aws_sfn_state_machine.this[0].status, "")
}

output "state_machine_version_arn" {
  description = "The ARN of state machine version"
  value       = try(aws_sfn_state_machine.this[0].state_machine_version_arn, "")
}

# IAM Role
output "role_arn" {
  description = "The ARN of the IAM role created for the Step Function"
  value       = try(aws_iam_role.this[0].arn, "")
}

output "role_name" {
  description = "The name of the IAM role created for the Step Function"
  value       = try(aws_iam_role.this[0].name, "")
}

# CloudWatch
output "cloudwatch_log_group_arn" {
  description = "The ARN of the CloudWatch log group created for the Step Function"
  value       = try(aws_cloudwatch_log_group.sfn[0].arn, "")
}

output "cloudwatch_log_group_name" {
  description = "The name of the CloudWatch log group created for the Step Function"
  value       = try(aws_cloudwatch_log_group.sfn[0].name, "")
}
