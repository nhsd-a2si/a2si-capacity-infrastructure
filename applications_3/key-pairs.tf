# Note the contnet type of the object needes to be text/plain
data "aws_s3_bucket_object" "certificate_rsa_pub" {
  bucket = "${var.environment}-certificates"
  key    = "${var.environment}_rsa.pub"
}


resource "aws_key_pair" "key-pair-dev" {
  key_name = "${var.environment}_rsa"
  public_key = "${data.aws_s3_bucket_object.certificate_rsa_pub.body}"
}
