terraform {
  backend "s3" {
    bucket         = "a2si-capacity-terraform-state"
    key            = "dev"
    dynamodb_table = "a2si-capacity-terraform-state"
    region         = "eu-west-2"
  }
}
