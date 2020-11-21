# State Machine
output "this_state_machine_id" {
  description = "The ARN of the State Machine"
  value       = module.step_function.this_state_machine_id
}

output "this_state_machine_arn" {
  description = "The ARN of the State Machine"
  value       = module.step_function.this_state_machine_arn
}

output "this_state_machine_creation_date" {
  description = "The date the State Machine was created"
  value       = module.step_function.this_state_machine_creation_date
}

output "this_state_machine_status" {
  description = "The current status of the State Machine"
  value       = module.step_function.this_state_machine_status
}

# IAM Role
output "this_role_arn" {
  description = "The ARN of the IAM role created for the State Machine"
  value       = module.step_function.this_role_arn
}

output "this_role_name" {
  description = "The name of the IAM role created for the State Machine"
  value       = module.step_function.this_role_name
}
