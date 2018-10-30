terraform {
  backend "s3" {
    bucket         = "a2si-cd-geha1-tf-state"
    key            = "geha1"
    dynamodb_table = "a2si-cd-geha1-state"
    region         = "eu-west-2"
  }
}

