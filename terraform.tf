terraform {
  backend "s3" {
    bucket         = "jp-tf-state-bucket"
    key            = "dev"
    dynamodb_table = "tf_lock"
    region         = "us-east-1"
  }
}
