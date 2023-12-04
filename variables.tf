variable "create" {
  description = "Whether to create Step Function resource"
  type        = bool
  default     = true
}

variable "create_role" {
  description = "Whether to create IAM role for the Step Function"
  type        = bool
  default     = true
}

variable "use_existing_role" {
  description = "Whether to use an existing IAM role for this Step Function"
  type        = bool
  default     = false
}

variable "use_existing_cloudwatch_log_group" {
  description = "Whether to use an existing CloudWatch log group or create new"
  type        = bool
  default     = false
}

################
# Step Function
################

variable "name" {
  description = "The name of the Step Function"
  type        = string
  default     = ""
}

variable "definition" {
  description = "The Amazon States Language definition of the Step Function"
  type        = string
  default     = ""
}

variable "role_arn" {
  description = "The Amazon Resource Name (ARN) of the IAM role to use for this Step Function"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Maps of tags to assign to the Step Function"
  type        = map(string)
  default     = {}
}

variable "type" {
  description = "Determines whether a Standard or Express state machine is created. The default is STANDARD. Valid Values: STANDARD | EXPRESS"
  type        = string
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "EXPRESS"], upper(var.type))
    error_message = "Step Function type must be one of the following (STANDARD | EXPRESS)."
  }
}

variable "sfn_state_machine_timeouts" {
  description = "Create, update, and delete timeout configurations for the step function."
  type        = map(string)
  default     = {}
}

variable "publish" {
  description = "Determines whether to set a version of the state machine when it is created."
  type        = bool
  default     = false
}

#################
# CloudWatch Logs
#################

variable "logging_configuration" {
  description = "Defines what execution history events are logged and where they are logged"
  type        = map(string)
  default     = {}
}

variable "cloudwatch_log_group_name" {
  description = "Name of Cloudwatch Logs group name to use."
  type        = string
  default     = null
}

variable "cloudwatch_log_group_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653."
  type        = number
  default     = null
}

variable "cloudwatch_log_group_kms_key_id" {
  description = "The ARN of the KMS Key to use when encrypting log data."
  type        = string
  default     = null
}

variable "cloudwatch_log_group_tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "attach_cloudwatch_logs_policy" {
  description = "Controls whether CloudWatch Logs policy should be added to IAM role for Lambda Function"
  type        = bool
  default     = true
}

###########
# IAM Role
###########

variable "aws_region_assume_role" {
  description = "Name of AWS regions where IAM role can be assumed by the Step Function"
  type        = string
  default     = ""
}

variable "role_name" {
  description = "Name of IAM role to use for Step Function"
  type        = string
  default     = null
}

variable "role_description" {
  description = "Description of IAM role to use for Step Function"
  type        = string
  default     = null
}

variable "role_path" {
  description = "Path of IAM role to use for Step Function"
  type        = string
  default     = null
}

variable "role_force_detach_policies" {
  description = "Specifies to force detaching any policies the IAM role has before destroying it."
  type        = bool
  default     = true
}

variable "role_permissions_boundary" {
  description = "The ARN of the policy that is used to set the permissions boundary for the IAM role used by Step Function"
  type        = string
  default     = null
}

variable "role_tags" {
  description = "A map of tags to assign to IAM role"
  type        = map(string)
  default     = {}
}

#####################################################
# Predefined IAM Policies for supported AWS Services
# (Lambda, DynamoDB, ECS, EKS, EMR, SageMaker, ...)
#####################################################

variable "attach_policies_for_integrations" {
  description = "Whether to attach AWS Service policies to IAM role"
  type        = bool
  default     = true
}

variable "service_integrations" {
  description = "Map of AWS service integrations to allow in IAM role policy"
  type        = any
  default     = {}
}

##########################
# Various custom policies
##########################

variable "attach_policy_json" {
  description = "Controls whether policy_json should be added to IAM role"
  type        = bool
  default     = false
}

variable "attach_policy_jsons" {
  description = "Controls whether policy_jsons should be added to IAM role"
  type        = bool
  default     = false
}

variable "attach_policy" {
  description = "Controls whether policy should be added to IAM role"
  type        = bool
  default     = false
}

variable "attach_policies" {
  description = "Controls whether list of policies should be added to IAM role"
  type        = bool
  default     = false
}

variable "number_of_policy_jsons" {
  description = "Number of policies JSON to attach to IAM role"
  type        = number
  default     = 0
}

variable "number_of_policies" {
  description = "Number of policies to attach to IAM role"
  type        = number
  default     = 0
}

variable "attach_policy_statements" {
  description = "Controls whether policy_statements should be added to IAM role"
  type        = bool
  default     = false
}

variable "trusted_entities" {
  description = "Step Function additional trusted entities for assuming roles (trust relationship)"
  type        = list(string)
  default     = []
}

variable "policy_json" {
  description = "An additional policy document as JSON to attach to IAM role"
  type        = string
  default     = null
}

variable "policy_jsons" {
  description = "List of additional policy documents as JSON to attach to IAM role"
  type        = list(string)
  default     = []
}

variable "policy" {
  description = "An additional policy document ARN to attach to IAM role"
  type        = string
  default     = null
}

variable "policy_path" {
  description = "Path of IAM policies to use for Step Function"
  type        = string
  default     = null
}

variable "policies" {
  description = "List of policy statements ARN to attach to IAM role"
  type        = list(string)
  default     = []
}

variable "policy_statements" {
  description = "Map of dynamic policy statements to attach to IAM role"
  type        = any
  default     = {}
}
