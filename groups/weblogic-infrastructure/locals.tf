locals {

  ec2_data                 = data.vault_generic_secret.ec2_data.data

  chs_cidrs                = values(data.vault_generic_secret.chs_cidrs.data)
  application_subnet_cidrs = [for s in data.aws_subnet.application : s.cidr_block]
  test_cidrs               = jsondecode(data.vault_generic_secret.test_cidrs.data["cidrs"])

  internal_fqdn = format("%s.%s.aws.internal", split("-", var.aws_account)[1], split("-", var.aws_account)[0])

  security_kms_keys_data = data.vault_generic_secret.security_kms_keys.data
  kms_keys_data          = data.vault_generic_secret.kms_keys.data
  logs_kms_key_id        = local.kms_keys_data["logs"]
  ssm_kms_key_id         = local.security_kms_keys_data["session-manager-kms-key-arn"]
  sns_kms_key_id         = local.kms_keys_data["sns"]

  security_s3_data            = data.vault_generic_secret.security_s3_buckets.data
  session_manager_bucket_name = local.security_s3_data["session-manager-bucket-name"]

  elb_access_logs_prefix      = "elb-access-logs"
  elb_access_logs_bucket_name = local.security_s3_data["elb-access-logs-bucket-name"]

  nfs_mounts = jsondecode(data.vault_generic_secret.nfs_mounts.data["${var.application}-mounts"])

  #For each log map passed, add an extra kv for the log group name and append the NFS directory into the filepath where required
  log_directory_prefix = format("%s/%s", var.nfs_mount_destination_parent_dir, lookup(local.nfs_mounts["application_root"], "local_mount_point", ""))
  cloudwatch_instance_logs = {
    for log, map in var.cloudwatch_logs :
    log => merge(map, {
      "log_group_name" = "${var.application}-${log}",
      "file_path"      = replace(map["file_path"], "NFSPATH", "${local.log_directory_prefix}/APPINSTANCENAME")
      }
    )
  }

  cloudwatch_weblogic_logs = {
    for env in var.environments : 
    env.name => {
      log_group_name      = "${var.application}-${env.name}-wlserver1-out"
      file_path           = "${local.log_directory_prefix}/${env.name}/running-servers/wlserver1/logs"
      file_name           = "wlserver1.out"
      log_group_retention = 7
    }    
  }

  cloudwatch_logs = merge(local.cloudwatch_instance_logs, local.cloudwatch_weblogic_logs)

  # Extract the log group names for easier iteration
  log_groups = compact([for log, map in local.cloudwatch_logs : lookup(map, "log_group_name", "")])

  default_tags = {
    Terraform       = "true"
    Application     = upper(var.application)
    ApplicationType = upper(var.application_type)
    Region          = var.aws_region
    Account         = var.aws_account
    Repository      = "chips-devtest-terraform"
    Service         = "CHIPS"
  }

  userdata_ansible_inputs = {
    mounts_parent_dir          = var.nfs_mount_destination_parent_dir
    mounts                     = local.nfs_mounts
    install_watcher_service    = false
    cw_log_files               = local.cloudwatch_logs
    cw_agent_user              = "root"
  }
}
