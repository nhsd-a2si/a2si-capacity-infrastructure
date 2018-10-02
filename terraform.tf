terraform {
  backend "s3" {
    bucket         = "a2si-cd-uat-tf-state"
    key            = "uat"
    dynamodb_table = "a2si-cd-uat-tf-state"
    region         = "eu-west-2"
  }
}
