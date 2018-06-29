# Note the contnet type of the object needes to be text/plain
data "aws_s3_bucket_object" "release_id" {
  bucket = "uat-certificates"
  key    = "uat_rsa.pub"
}


resource "aws_key_pair" "key-pair-dev" {
  key_name = "${var.nhs_owner_shortcode}-key-pair-dev"
  public_key = "${data.aws_s3_bucket_object.release_id.body}"
}
