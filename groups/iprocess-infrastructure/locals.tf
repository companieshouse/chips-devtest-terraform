locals {

  s3_releases              = data.vault_generic_secret.s3_releases.data
  iprocess_app_ec2_data    = data.vault_generic_secret.iprocess_app_ec2_data.data
  iprocess_app_config_data = data.vault_generic_secret.iprocess_app_config_data.data

  internal_fqdn = format("%s.%s.aws.internal", split("-", var.aws_account)[1], split("-", var.aws_account)[0])

  security_kms_keys_data = data.vault_generic_secret.security_kms_keys.data
  kms_keys_data          = data.vault_generic_secret.kms_keys.data
  account_ssm_key_arn    = local.kms_keys_data["ssm"]
  logs_kms_key_id        = local.kms_keys_data["logs"]
  ssm_kms_key_id         = local.security_kms_keys_data["session-manager-kms-key-arn"]
  sns_kms_key_id         = local.kms_keys_data["sns"]

  security_s3_data            = data.vault_generic_secret.security_s3_buckets.data
  session_manager_bucket_name = local.security_s3_data["session-manager-bucket-name"]

  spo_access_source_sg_ids = flatten([for sg in data.aws_security_groups.spo_access_group_ids : sg.ids])
  spo_access_source_groups = {for group in data.aws_security_group.spo_access_groups : group.tags.Name => group.id}

  cloudwatch_instance_logs = {
    for log, map in var.cloudwatch_logs :
    log => merge(map, {
      "log_group_name" = "${var.application}-${var.environment}-${log}"
      }
    )
  }

  # Extract the log group names for easier iteration
  log_groups = compact([for log, map in local.cloudwatch_instance_logs : lookup(map, "log_group_name", "")])

  default_tags = {
    Terraform       = "true"
    Application     = upper(var.application)
    ApplicationType = upper(var.application_type)
    Environment     = var.environment
    Region          = var.aws_region
    Account         = var.aws_account
    Repository      = "chips-devtest-terraform"
    Service         = "CHIPS"
  }

  iprocess_app_deployment_ansible_inputs = {
    HOSTNAME             = format("%s-%s", var.application, var.environment)
    DOMAIN               = local.internal_fqdn
    APP_TCP_PORT         = local.iprocess_app_config_data["app_tcp_port"]
    EAI_DB_PASS          = local.iprocess_app_config_data["eai_db_password"]
    EAI_DB_SCHEMAOWNER   = local.iprocess_app_config_data["eai_db_schemaowner"]
    EAI_DB_USER          = local.iprocess_app_config_data["eai_db_user"]
    ORACLE_SID_VALUE     = local.iprocess_app_config_data["oracle_std_sid"]
    DB_ADDRESS           = local.iprocess_app_config_data["db_address"]
    DB_PORT              = local.iprocess_app_config_data["db_port"]
    SWPRO_PASSWORD       = local.iprocess_app_config_data["swpro_password"]
    region               = var.aws_region
    cw_log_files         = local.cloudwatch_instance_logs
    cw_agent_user        = "root"
    cw_namespace         = var.cloudwatch_namespace
    cw_asg_level_metrics = "true"
    s3_bucket_configs    = local.s3_releases["config_bucket_name"]
    crontab_filename     = "dev-crontab.txt"
  }

  iprocess_tnsnames_inputs = {
    db_address     = local.iprocess_app_config_data["db_address"]
    db_port        = local.iprocess_app_config_data["db_port"]
    oracle_std_sid = local.iprocess_app_config_data["oracle_std_sid"]
    oracle_taf_sid = local.iprocess_app_config_data["oracle_taf_sid"]
    service_name   = local.iprocess_app_config_data["service_name"]
  }

  iprocess_staff_dat_inputs = {
    staff_dat = local.iprocess_app_config_data["staff_dat"]
  }

  parameter_store_path_prefix = "/${var.application}/${var.environment}"

  parameter_store_secrets = {
    deployment_ansible_inputs = jsonencode(local.iprocess_app_deployment_ansible_inputs)
    tnsnames_inputs           = jsonencode(local.iprocess_tnsnames_inputs)
    staff_dat_inputs          = jsonencode(local.iprocess_staff_dat_inputs)
  }
}
