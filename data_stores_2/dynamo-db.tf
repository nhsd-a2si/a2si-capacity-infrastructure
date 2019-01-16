resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "${var.environment}-authentication"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "ClientId"
//  range_key      = "GameTitle"

  attribute {
    name = "CLIENT_ID"
    type = "S"
  }

  attribute {
    name = "USERNAME"
    type = "S"
  }

  attribute {
    name = "SALTED_PASSWORD"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  // To do: Define backup procedure

  tags {
    Environment = "${var.environment}"
    Name = "Authentication-DB"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Version = "${var.deployment_version}"
    Terraform = "true"
  }
}
