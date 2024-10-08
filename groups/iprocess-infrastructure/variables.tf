# ------------------------------------------------------------------------------
# Vault Variables
# ------------------------------------------------------------------------------
variable "vault_username" {
  type        = string
  description = "Username for connecting to Vault - usually supplied through TF_VARS"
}

variable "vault_password" {
  type        = string
  description = "Password for connecting to Vault - usually supplied through TF_VARS"
}

# ------------------------------------------------------------------------------
# AWS Variables
# ------------------------------------------------------------------------------
variable "aws_region" {
  type        = string
  description = "The AWS region in which resources will be administered"
}

variable "aws_profile" {
  type        = string
  description = "The AWS profile to use"
}

variable "aws_account" {
  type        = string
  description = "The name of the AWS Account in which resources will be administered"
}

# ------------------------------------------------------------------------------
# AWS Variables - Shorthand
# ------------------------------------------------------------------------------

variable "account" {
  type        = string
  description = "Short version of the name of the AWS Account in which resources will be administered"
}

variable "region" {
  type        = string
  description = "Short version of the name of the AWS region in which resources will be administered"
}

# ------------------------------------------------------------------------------
# Environment Variables
# ------------------------------------------------------------------------------

variable "application" {
  type        = string
  description = "The component name of the application"
}

variable "environment" {
  type        = string
  description = "The name of the environment"
}

variable "application_type" {
  type        = string
  default     = "chips"
  description = "The parent name of the application"
}

# ------------------------------------------------------------------------------
# ASG Variables
# ------------------------------------------------------------------------------

variable "instance_size" {
  type        = string
  description = "The size of the ec2 instances to build"
}

variable "asg_min_size" {
  type        = number
  default     = 1
  description = "The min size of the ASG - always 1"
}

variable "asg_max_size" {
  type        = number
  default     = 1
  description = "The max size of the ASG - always 1"
}

variable "asg_desired_capacity" {
  type        = number
  default     = 1
  description = "The desired capacity of ASG - always 1"
}

variable "asg_count" {
  type        = number
  description = "The number of ASGs - typically 1 for dev and 2 for staging/live"
}

variable "ami_name" {
  type        = string
  default     = "iprocess-app-*"
  description = "Name of the AMI to use in the Auto Scaling configuration"
}

variable "instance_root_volume_size" {
  type        = number
  default     = 100
  description = "Size of root volume attached to instances"
}

variable "instance_root_volume_type" {
  type        = string
  default     = "gp3"
  description = "The EC2 instance root volume type"
}

variable "instance_swap_volume_size" {
  type        = number
  default     = 5
  description = "Size of swap volume attached to instances"
}

variable "enforce_imdsv2" {
  description = "Whether to enforce use of IMDSv2 by setting http_tokens to required on the aws_launch_configuration"
  type        = bool
  default     = true
}

variable "enable_instance_refresh" {
  type        = bool
  default     = false
  description = "Enable or disable instance refresh when the ASG is updated"
}

variable "default_log_group_retention_in_days" {
  type        = number
  default     = 14
  description = "Total days to retain logs in CloudWatch log group if not specified for specific logs"
}

variable "cloudwatch_logs" {
  type        = map(any)
  default     = {}
  description = "Map of log file information; used to create log groups, IAM permissions and passed to the application to configure remote logging"
}

variable "cloudwatch_namespace" {
  type        = string
  default     = "CHIPS/STFWARE"
  description = "A custom namespace to define for CloudWatch custom metrics such as memory and disk"
}

variable "enable_sns_topic" {
  type        = bool
  default     = false
  description = "A boolean value to indicate whether to deploy SNS topic configuration for CloudWatch actions"
}

variable "spo_access_sg_patterns" {
  type        = list(string)
  default     = []
  description = "List of source security group name patterns that will have access to the SPO ports"
}
