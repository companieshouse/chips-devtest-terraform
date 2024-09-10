data "vault_generic_secret" "nfs_mounts" {
  path = "applications/${var.aws_account}-${var.aws_region}/${var.application_type}/app/nfs_mounts"
}

data "aws_autoscaling_groups" "asg" {
  filter {
    name   = "tag:Name"
    values = ["${local.application_name}0"]
  }
}
