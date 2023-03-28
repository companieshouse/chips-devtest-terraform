resource "aws_key_pair" "iprocess_app_keypair" {
  key_name   = "${var.application}-${var.environment}"
  public_key = local.iprocess_app_ec2_data["public-key"]
}