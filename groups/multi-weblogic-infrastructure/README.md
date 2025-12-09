<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3, < 2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 6.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 4.0, < 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | 4.8.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_chips-app"></a> [chips-app](#module\_chips-app) | git@github.com:companieshouse/terraform-modules//aws/chips-app | tags/1.0.363 |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_managed_prefix_list.admin_cidr_ranges](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_managed_prefix_list) | data source |
| [aws_ec2_managed_prefix_list.on_premise_cidr_ranges](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_managed_prefix_list) | data source |
| [vault_generic_secret.nfs_mounts](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_health_check_path"></a> [admin\_health\_check\_path](#input\_admin\_health\_check\_path) | Target group health check path for administration console | `string` | `"/console"` | no |
| <a name="input_admin_port"></a> [admin\_port](#input\_admin\_port) | Target group backend port for administration | `number` | `21001` | no |
| <a name="input_alb_deletion_protection"></a> [alb\_deletion\_protection](#input\_alb\_deletion\_protection) | Enable or disable deletion protection for instances | `bool` | `false` | no |
| <a name="input_ami_name"></a> [ami\_name](#input\_ami\_name) | Name of the AMI to use in the Auto Scaling configuration | `string` | `"docker-ami-*"` | no |
| <a name="input_app_health_check_path"></a> [app\_health\_check\_path](#input\_app\_health\_check\_path) | Target group health check path for application | `string` | `"/"` | no |
| <a name="input_application_port"></a> [application\_port](#input\_application\_port) | Target group backend port for application | `number` | `21000` | no |
| <a name="input_application_type"></a> [application\_type](#input\_application\_type) | The parent name of the application | `string` | `"chips"` | no |
| <a name="input_asg_count"></a> [asg\_count](#input\_asg\_count) | The number of ASGs - typically 1 for dev and 2 for staging/live | `number` | `1` | no |
| <a name="input_asg_desired_capacity"></a> [asg\_desired\_capacity](#input\_asg\_desired\_capacity) | The desired capacity of ASG - always 1 | `number` | `1` | no |
| <a name="input_asg_max_size"></a> [asg\_max\_size](#input\_asg\_max\_size) | The max size of the ASG - always 1 | `number` | `1` | no |
| <a name="input_asg_min_size"></a> [asg\_min\_size](#input\_asg\_min\_size) | The min size of the ASG - always 1 | `number` | `1` | no |
| <a name="input_aws_account"></a> [aws\_account](#input\_aws\_account) | The name of the AWS Account in which resources will be administered | `string` | `"heritage-development"` | no |
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | The AWS profile to use | `string` | `"heritage-development-eu-west-2"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region in which resources will be administered | `string` | `"eu-west-2"` | no |
| <a name="input_bootstrap_commands"></a> [bootstrap\_commands](#input\_bootstrap\_commands) | List of bootstrap commands to run during the instance startup | `list(string)` | <pre>[<br/>  "su -l ec2-user set-container-alias.sh build build weblogic",<br/>  "su -l ec2-user weblogic-pre-bootstrap.sh",<br/>  "su -l ec2-user load-cached-images.sh",<br/>  "su -l ec2-user bootstrap"<br/>]</pre> | no |
| <a name="input_cloudwatch_logs"></a> [cloudwatch\_logs](#input\_cloudwatch\_logs) | Map of log file information; used to create log groups, IAM permissions and passed to the application to configure remote logging | `map(any)` | <pre>{<br/>  "apache-access": {<br/>    "file_name": "access.log",<br/>    "file_path": "NFSPATH/running-servers/apache",<br/>    "log_group_retention": 7<br/>  },<br/>  "apache-admin-access": {<br/>    "file_name": "admin-access.log",<br/>    "file_path": "NFSPATH/running-servers/apache",<br/>    "log_group_retention": 7<br/>  },<br/>  "apache-admin-error": {<br/>    "file_name": "admin-error.log",<br/>    "file_path": "NFSPATH/running-servers/apache",<br/>    "log_group_retention": 7<br/>  },<br/>  "apache-error": {<br/>    "file_name": "error.log",<br/>    "file_path": "NFSPATH/running-servers/apache",<br/>    "log_group_retention": 7<br/>  },<br/>  "audit.log": {<br/>    "file_path": "/var/log/audit",<br/>    "log_group_retention": 7<br/>  },<br/>  "build-failure-log": {<br/>    "file_name": "build_failure.log",<br/>    "file_path": "NFSPATH/running-servers/buildlogs",<br/>    "log_group_retention": 7<br/>  },<br/>  "eaidaemon-log": {<br/>    "file_name": "eai-eaidaemon-*.log",<br/>    "file_path": "NFSPATH/running-servers/eaidaemon",<br/>    "log_group_retention": 7<br/>  },<br/>  "full-build-test-deploy-log": {<br/>    "file_name": "full-build-test-deploy-*.log",<br/>    "file_path": "NFSPATH/running-servers/buildlogs",<br/>    "log_group_retention": 7<br/>  },<br/>  "full-monty-build-log": {<br/>    "file_name": "full-monty-*.log",<br/>    "file_path": "NFSPATH/running-servers/buildlogs",<br/>    "log_group_retention": 7<br/>  },<br/>  "messages": {<br/>    "file_path": "/var/log",<br/>    "log_group_retention": 7<br/>  },<br/>  "quick-build-deploy-log": {<br/>    "file_name": "quick-build-deploy-*.log",<br/>    "file_path": "NFSPATH/running-servers/buildlogs",<br/>    "log_group_retention": 7<br/>  },<br/>  "secure": {<br/>    "file_path": "/var/log",<br/>    "log_group_retention": 7<br/>  },<br/>  "ssm-agent": {<br/>    "file_name": "amazon-ssm-agent.log",<br/>    "file_path": "/var/log/amazon/ssm",<br/>    "log_group_retention": 7<br/>  },<br/>  "ssm-errors": {<br/>    "file_name": "errors.log",<br/>    "file_path": "/var/log/amazon/ssm",<br/>    "log_group_retention": 7<br/>  },<br/>  "sso1-log": {<br/>    "file_name": "sso1-ssodaemon-*.log",<br/>    "file_path": "NFSPATH/running-servers/ssodaemon",<br/>    "log_group_retention": 7<br/>  },<br/>  "wladmin-access": {<br/>    "file_name": "access.log",<br/>    "file_path": "NFSPATH/running-servers/wladmin/logs",<br/>    "log_group_retention": 7<br/>  },<br/>  "wladmin-chipsdomain": {<br/>    "file_name": "chipsdomain.log",<br/>    "file_path": "NFSPATH/running-servers/wladmin/logs",<br/>    "log_group_retention": 7<br/>  },<br/>  "wladmin-log": {<br/>    "file_name": "wladmin.log",<br/>    "file_path": "NFSPATH/running-servers/wladmin/logs",<br/>    "log_group_retention": 7<br/>  },<br/>  "wlserver1-access": {<br/>    "file_name": "access.log",<br/>    "file_path": "NFSPATH/running-servers/wlserver1/logs",<br/>    "log_group_retention": 7<br/>  },<br/>  "wlserver1-log": {<br/>    "file_name": "wlserver1.log",<br/>    "file_path": "NFSPATH/running-servers/wlserver1/logs",<br/>    "log_group_retention": 7<br/>  },<br/>  "wlserver1-out": {<br/>    "file_name": "wlserver1.out",<br/>    "file_path": "NFSPATH/running-servers/wlserver1/logs",<br/>    "log_group_retention": 7<br/>  },<br/>  "yum.log": {<br/>    "file_path": "/var/log",<br/>    "log_group_retention": 7<br/>  }<br/>}</pre> | no |
| <a name="input_concourse_access_enable"></a> [concourse\_access\_enable](#input\_concourse\_access\_enable) | Enable shared services concourse access | `bool` | `false` | no |
| <a name="input_config_base_path_override"></a> [config\_base\_path\_override](#input\_config\_base\_path\_override) | Path within the config bucket the application will use to retrieve configuration files | `string` | `"chips-e2e-configs"` | no |
| <a name="input_config_bucket_name"></a> [config\_bucket\_name](#input\_config\_bucket\_name) | Bucket name the application will use to retrieve configuration files | `string` | `"heritage-development.eu-west-2.configs.ch.gov.uk"` | no |
| <a name="input_default_log_group_retention_in_days"></a> [default\_log\_group\_retention\_in\_days](#input\_default\_log\_group\_retention\_in\_days) | Total days to retain logs in CloudWatch log group if not specified for specific logs | `number` | `14` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain Name for ACM Certificate | `string` | `"*.companieshouse.gov.uk"` | no |
| <a name="input_e2e_name"></a> [e2e\_name](#input\_e2e\_name) | The name of the e2e environment | `string` | n/a | yes |
| <a name="input_enable_instance_refresh"></a> [enable\_instance\_refresh](#input\_enable\_instance\_refresh) | Enable or disable instance refresh when the ASG is updated | `bool` | `true` | no |
| <a name="input_enable_sns_topic"></a> [enable\_sns\_topic](#input\_enable\_sns\_topic) | A boolean value to indicate whether to deploy SNS topic configuration for CloudWatch actions | `bool` | `false` | no |
| <a name="input_instance_root_volume_size"></a> [instance\_root\_volume\_size](#input\_instance\_root\_volume\_size) | Size of root volume attached to instances | `number` | `40` | no |
| <a name="input_instance_size"></a> [instance\_size](#input\_instance\_size) | The size of the ec2 instances to build | `string` | `"t3.large"` | no |
| <a name="input_nfs_mount_destination_parent_dir"></a> [nfs\_mount\_destination\_parent\_dir](#input\_nfs\_mount\_destination\_parent\_dir) | The parent folder that all NFS shares should be mounted inside on the EC2 instance | `string` | `"/mnt/nfs"` | no |
| <a name="input_post_bootstrap_commands"></a> [post\_bootstrap\_commands](#input\_post\_bootstrap\_commands) | List of commands to run after the bootstrap commands on instance startup | `list(string)` | `[]` | no |
| <a name="input_short_account"></a> [short\_account](#input\_short\_account) | Short version of the name of the AWS Account in which resources will be administered | `string` | `"hdev"` | no |
| <a name="input_short_region"></a> [short\_region](#input\_short\_region) | Short version of the name of the AWS region in which resources will be administered | `string` | `"euw2"` | no |
| <a name="input_shutdown_schedule"></a> [shutdown\_schedule](#input\_shutdown\_schedule) | Cron expression for the shutdown time - e.g. '00 20 * * 1-5' is 8pm Mon-Fri | `string` | `null` | no |
| <a name="input_ssh_access_security_group_patterns"></a> [ssh\_access\_security\_group\_patterns](#input\_ssh\_access\_security\_group\_patterns) | List of source security group name patterns that will have SSH access | `list(string)` | <pre>[<br/>  "sgr-chips-control-asg-001-*"<br/>]</pre> | no |
| <a name="input_startup_schedule"></a> [startup\_schedule](#input\_startup\_schedule) | Cron expression for the startup time - e.g. '00 06 * * 1-5' is 6am Mon-Fri | `string` | `null` | no |
| <a name="input_vault_password"></a> [vault\_password](#input\_vault\_password) | Password for connecting to Vault - usually supplied through TF\_VARS | `string` | n/a | yes |
| <a name="input_vault_username"></a> [vault\_username](#input\_vault\_username) | Username for connecting to Vault - usually supplied through TF\_VARS | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->