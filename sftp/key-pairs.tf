resource "aws_key_pair" "key-pair-dev" {
  key_name = "${var.nhs_owner_shortcode}-sftp-key-pair-dev"
  public_key = "${file("key-pair-dev.pub")}"
}
