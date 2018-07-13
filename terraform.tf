terraform {
  backend "s3" {
    bucket         = "nima-tf-state"
    key            = "dev"
    dynamodb_table = "nima-tf-state"
    region         = "eu-west-2"
  }
}
