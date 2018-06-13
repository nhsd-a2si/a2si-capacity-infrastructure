terraform {
  backend "s3" {
    bucket         = "nm-tf-state-bucket"
    key            = "dev"
    dynamodb_table = "a2si-capacity-terraform-state"
    region         = "eu-west-2"
  }
}
