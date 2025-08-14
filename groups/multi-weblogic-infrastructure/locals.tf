locals {
  application_name = "chips-${var.e2e_name}"

  on_premise_cidr_ranges = flatten([
    for entry in data.aws_ec2_managed_prefix_list.on_premise_cidr_ranges.entries : [
      entry.cidr
    ]
  ])
}
