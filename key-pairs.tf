resource "aws_key_pair" "key-pair-dev" {
  key_name = "key-pair-dev"
  public_key = "${file("key-pair-dev.pub")}"
}