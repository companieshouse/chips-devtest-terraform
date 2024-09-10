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
  default     = "eu-west-2"
  description = "The AWS region in which resources will be administered"
}

variable "aws_profile" {
  type        = string
  default     = "heritage-development-eu-west-2"
  description = "The AWS profile to use"
}

variable "aws_account" {
  type        = string
  default     = "heritage-development"
  description = "The name of the AWS Account in which resources will be administered"
}

# ------------------------------------------------------------------------------
# AWS Variables - Shorthand
# ------------------------------------------------------------------------------

variable "short_account" {
  type        = string
  default     = "hdev"
  description = "Short version of the name of the AWS Account in which resources will be administered"
}

variable "short_region" {
  type        = string
  default     = "euw2"
  description = "Short version of the name of the AWS region in which resources will be administered"
}

# ------------------------------------------------------------------------------
# Environment Variables
# ------------------------------------------------------------------------------

variable "e2e_name" {
  type        = string
  description = "The name of the e2e environment"
}

variable "application_type" {
  type        = string
  default     = "chips"
  description = "The parent name of the application"
}

# ------------------------------------------------------------------------------
# CHIPS ASG Variables
# ------------------------------------------------------------------------------

variable "instance_size" {
  type        = string
  default     = "t3.large"
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
  default     = 1
  description = "The number of ASGs - typically 1 for dev and 2 for staging/live"
}

variable "ami_name" {
  type        = string
  default     = "docker-ami-*"
  description = "Name of the AMI to use in the Auto Scaling configuration"
}

variable "instance_root_volume_size" {
  type        = number
  default     = 40
  description = "Size of root volume attached to instances"
}

variable "alb_deletion_protection" {
  type        = bool
  default     = false
  description = "Enable or disable deletion protection for instances"
}

variable "enable_instance_refresh" {
  type        = bool
  default     = true
  description = "Enable or disable instance refresh when the ASG is updated"
}

variable "ssh_access_security_group_patterns" {
  type        = list(string)
  description = "List of source security group name patterns that will have SSH access"
  default     = ["sgr-chips-control-asg-001-*"]
}

variable "config_bucket_name" {
  type        = string
  description = "Bucket name the application will use to retrieve configuration files"
  default     = "heritage-development.eu-west-2.configs.ch.gov.uk"
}

variable "config_base_path_override" {
  type        = string
  description = "Path within the config bucket the application will use to retrieve configuration files"
  default     = "chips-e2e-configs"
}

variable "shutdown_schedule" {
  type        = string
  description = "Cron expression for the shutdown time - e.g. '00 20 * * 1-5' is 8pm Mon-Fri"
  default     = "00 20 * * 1-5"
}

variable "startup_schedule" {
  type        = string
  description = "Cron expression for the startup time - e.g. '00 06 * * 1-5' is 6am Mon-Fri"
  default     = "00 06 * * 1-5"
}

# ------------------------------------------------------------------------------
# CHIPS ALB Variables
# ------------------------------------------------------------------------------

variable "application_port" {
  type        = number
  default     = 21000
  description = "Target group backend port for application"
}

variable "admin_port" {
  type        = number
  default     = 21001
  description = "Target group backend port for administration"
}

variable "app_health_check_path" {
  type        = string
  default     = "/"
  description = "Target group health check path for application"
}

variable "admin_health_check_path" {
  type        = string
  default     = "/console"
  description = "Target group health check path for administration console"
}

variable "domain_name" {
  type        = string
  default     = "*.companieshouse.gov.uk"
  description = "Domain Name for ACM Certificate"
}

# ------------------------------------------------------------------------------
# NFS Mount Variables
# ------------------------------------------------------------------------------
# See Ansible role for full documentation on NFS arguements:
#      https://github.com/companieshouse/ansible-collections/tree/main/ch_collections/heritage_services/roles/nfs/files/nfs_mounts
variable "nfs_mount_destination_parent_dir" {
  type        = string
  default     = "/mnt/nfs"
  description = "The parent folder that all NFS shares should be mounted inside on the EC2 instance"
}

variable "default_log_group_retention_in_days" {
  type        = number
  default     = 14
  description = "Total days to retain logs in CloudWatch log group if not specified for specific logs"
}

variable "cloudwatch_logs" {
  type        = map(any)
  default     = {
    "audit.log" = {
      file_path = "/var/log/audit"
      log_group_retention = 7
    }

    "messages" = {
      file_path = "/var/log"
      log_group_retention = 7
    }
    
    "secure" = {
      file_path = "/var/log"
      log_group_retention = 7
    }

    "yum.log" = {
      file_path = "/var/log"
      log_group_retention = 7
    }

    "ssm-errors" = {
      file_path = "/var/log/amazon/ssm"
      file_name = "errors.log"
      log_group_retention = 7
    }

    "ssm-agent" = {
      file_path = "/var/log/amazon/ssm"
      file_name = "amazon-ssm-agent.log"
      log_group_retention = 7
    }

    "apache-access" = {
      file_path = "NFSPATH/running-servers/apache"
      file_name = "access.log"
      log_group_retention = 7
    }

    "apache-error" = {
      file_path = "NFSPATH/running-servers/apache"
      file_name = "error.log"
      log_group_retention = 7
    }

    "apache-admin-access" = {
      file_path = "NFSPATH/running-servers/apache"
      file_name = "admin-access.log"
      log_group_retention = 7
    }
    
    "apache-admin-error" = {
      file_path = "NFSPATH/running-servers/apache"
      file_name = "admin-error.log"
      log_group_retention = 7
    }

    "wlserver1-access" = {
      file_path = "NFSPATH/running-servers/wlserver1/logs"
      file_name = "access.log"
      log_group_retention = 7
    }

    "wlserver1-log" = {
      file_path = "NFSPATH/running-servers/wlserver1/logs"
      file_name = "wlserver1.log"
      log_group_retention = 7
    }

    "wlserver1-out" = {
      file_path = "NFSPATH/running-servers/wlserver1/logs"
      file_name = "wlserver1.out"
      log_group_retention = 7
    }

    "wladmin-access" = {
      file_path = "NFSPATH/running-servers/wladmin/logs"
      file_name = "access.log"
      log_group_retention = 7
    }

    "wladmin-log" = {
      file_path = "NFSPATH/running-servers/wladmin/logs"
      file_name = "wladmin.log"
      log_group_retention = 7
    }

    "wladmin-chipsdomain" = {
      file_path = "NFSPATH/running-servers/wladmin/logs"
      file_name = "chipsdomain.log"
      log_group_retention = 7
    }

    "sso1-log" = {
      file_path = "NFSPATH/running-servers/ssodaemon"
      file_name = "sso1-ssodaemon-*.log"
      log_group_retention = 7
    }

    "eaidaemon-log" = {
      file_path = "NFSPATH/running-servers/eaidaemon"
      file_name = "eai-eaidaemon-*.log"
      log_group_retention = 7
    }
  }
  description = "Map of log file information; used to create log groups, IAM permissions and passed to the application to configure remote logging"
}

variable "enable_sns_topic" {
  type        = bool
  default     = false
  description = "A boolean value to indicate whether to deploy SNS topic configuration for CloudWatch actions"
}

variable "bootstrap_commands" {
  type        = list(string)
  default     = [
    "su -l ec2-user weblogic-pre-bootstrap.sh",
    "su -l ec2-user bootstrap"
  ]
  description = "List of bootstrap commands to run during the instance startup"
}

variable "post_bootstrap_commands" {
  type        = list(string)
  default     = []
  description = "List of commands to run after the bootstrap commands on instance startup"
}
