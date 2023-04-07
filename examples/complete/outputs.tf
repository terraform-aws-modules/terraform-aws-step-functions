# State Machine
output "state_machine_id" {
  description = "The ARN of the State Machine"
  value       = module.step_function.state_machine_id
}

output "state_machine_arn" {
  description = "The ARN of the State Machine"
  value       = module.step_function.state_machine_arn
}

output "state_machine_creation_date" {
  description = "The date the State Machine was created"
  value       = module.step_function.state_machine_creation_date
}

output "state_machine_status" {
  description = "The current status of the State Machine"
  value       = module.step_function.state_machine_status
}

# IAM Role
output "role_arn" {
  description = "The ARN of the IAM role created for the State Machine"
  value       = module.step_function.role_arn
}

output "role_name" {
  description = "The name of the IAM role created for the State Machine"
  value       = module.step_function.role_name
}

# CloudWatch
output "cloudwatch_log_group_arn" {
  description = "The ARN of the CloudWatch log group created for the Step Function"
  value       = module.step_function.cloudwatch_log_group_arn
}

output "cloudwatch_log_group_name" {
  description = "The name of the CloudWatch log group created for the Step Function"
  value       = module.step_function.cloudwatch_log_group_name
}
