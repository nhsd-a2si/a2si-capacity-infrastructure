data "aws_s3_bucket" "eb_zip_versions_bucket"{
  bucket = "${var.s3_app_versions_bucket}"
}
