terraform {
  backend "s3" {
    bucket         = "a2si-cd-texas-tf-state"
    key            = "texas"
    dynamodb_table = "a2si-cd-texas-tf-state"
    region         = "eu-west-2"
  }
}
