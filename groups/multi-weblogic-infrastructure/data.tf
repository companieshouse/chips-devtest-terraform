data "vault_generic_secret" "nfs_mounts" {
  path = "applications/${var.aws_account}-${var.aws_region}/${var.application_type}/app/nfs_mounts"
}

data "aws_ec2_managed_prefix_list" "on_premise_cidr_ranges" {
  name = "on-premise-cidr-ranges"
}

data "aws_ec2_managed_prefix_list" "admin_cidr_ranges" {
  name = "administration-cidr-ranges"
}
