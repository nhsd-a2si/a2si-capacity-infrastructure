terraform {
  backend "s3" {
    bucket         = "a2si-cd-testp-tf-state"
    key            = "test-pilot"
    dynamodb_table = "a2si-cd-testp-tf-state"
    region         = "eu-west-2"
  }
}
