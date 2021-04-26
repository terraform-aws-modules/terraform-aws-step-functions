# Step Function
output "state_machine_id" {
  description = "The ARN of the Step Function"
  value       = element(concat(aws_sfn_state_machine.this.*.id, [""]), 0)
}

output "state_machine_arn" {
  description = "The ARN of the Step Function"
  value       = element(concat(aws_sfn_state_machine.this.*.arn, [""]), 0)
}

output "state_machine_creation_date" {
  description = "The date the Step Function was created"
  value       = element(concat(aws_sfn_state_machine.this.*.creation_date, [""]), 0)
}

output "state_machine_status" {
  description = "The current status of the Step Function"
  value       = element(concat(aws_sfn_state_machine.this.*.status, [""]), 0)
}

# IAM Role
output "role_arn" {
  description = "The ARN of the IAM role created for the Step Function"
  value       = element(concat(aws_iam_role.this.*.arn, [""]), 0)
}

output "role_name" {
  description = "The name of the IAM role created for the Step Function"
  value       = element(concat(aws_iam_role.this.*.name, [""]), 0)
}
