terraform {
  backend "s3" {
    bucket         = "a2si-capacity-terraform-state"
    key            = "dev"
    region         = "eu-west-1"
    dynamodb_table = "a2si-capacity-terraform-state"
  }
}
