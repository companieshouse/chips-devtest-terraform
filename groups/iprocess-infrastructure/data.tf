data "aws_caller_identity" "current" {}

data "aws_vpc" "vpc" {
  tags = {
    Name = "vpc-${var.aws_account}"
  }
}

data "aws_subnet_ids" "application" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["sub-application-*"]
  }
}

data "aws_security_group" "chips_devtest_app" {
  filter {
    name   = "group-name"
    values = ["sgr-chips-devtest-asg-001-*"]
  }
}

data "aws_security_group" "iprocess_rds" {
  filter {
    name   = "group-name"
    values = ["sgr-staffware-${var.environment}-rds-001-*"]
  }
}

data "aws_route53_zone" "private_zone" {
  name         = local.internal_fqdn
  private_zone = true
}

data "aws_ec2_managed_prefix_list" "administration" {
  name = "administration-cidr-ranges"
}

data "vault_generic_secret" "account_ids" {
  path = "aws-accounts/account-ids"
}

data "vault_generic_secret" "s3_releases" {
  path = "aws-accounts/shared-services/s3"
}

data "vault_generic_secret" "kms_keys" {
  path = "aws-accounts/${var.aws_account}/kms"
}

data "vault_generic_secret" "security_kms_keys" {
  path = "aws-accounts/security/kms"
}

data "vault_generic_secret" "security_s3_buckets" {
  path = "aws-accounts/security/s3"
}

data "vault_generic_secret" "iprocess_app_ec2_data" {
  path = "applications/${var.aws_account}-${var.aws_region}/${var.application}/app/ec2"
}

data "vault_generic_secret" "iprocess_app_config_data" {
  path = "applications/${var.aws_account}-${var.aws_region}/${var.application}-${var.environment}/app/iprocess"
}

# ------------------------------------------------------------------------------
# iProcess App data
# ------------------------------------------------------------------------------
data "aws_ami" "iprocess_app" {
  owners      = [data.vault_generic_secret.account_ids.data["development"]]
  most_recent = var.ami_name == "iprocess-app-*" ? true : false

  filter {
    name = "name"
    values = [
      var.ami_name,
    ]
  }

  filter {
    name = "state"
    values = [
      "available",
    ]
  }
}

data "template_file" "userdata" {
  template = file("${path.module}/templates/user_data.tpl")

  vars = {
    REGION                         = var.aws_region
    R53_ZONEID                     = data.aws_route53_zone.private_zone.zone_id
    DEPLOYMENT_ANSIBLE_INPUTS_PATH = "${local.parameter_store_path_prefix}/deployment_ansible_inputs"
    TNSNAMES_INPUTS_PATH           = "${local.parameter_store_path_prefix}/tnsnames_inputs"
    STAFF_DAT_INPUTS_PATH          = "${local.parameter_store_path_prefix}/staff_dat_inputs"
  }
}

data "template_cloudinit_config" "userdata_config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.userdata.rendered
  }
}