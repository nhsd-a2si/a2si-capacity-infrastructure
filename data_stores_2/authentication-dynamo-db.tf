#
# Defines the dynamo DB that stores authentication credentials for publicly_access
# to the capacity service APIs.
#
resource "aws_dynamodb_table" "capacity_authentication_dynamodb_table" {
  name           = "${var.environment}-authentication"
  billing_mode   = "PROVISIONED"
  read_capacity  = "${var.authentication_db_read_capacity_units}
  write_capacity = "${var.authentication_db_write_capacity_units}
  hash_key       = "ClientId"

  # Define attributes of the table
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

  # Enable encryption at rest
  server_side_encryption {
    enabled = true
  }

  # Enable backup configuration
  # For EarliestRestorableDateTime, you can restore your table to any point
  # in time during the last 35 days. The retention period is a fixed 35 days
  # five calendar weeks) and can't be modified. Any number of users can execute
  # up to four concurrent restores (any type of restore) in a given account.
  point_in_time_recovery {
    enabled = true
  }

  # Disable time to live so data stored is kept
  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  # Define tag attributes
  tags {
    Environment = "${var.environment}"
    Name = "Authentication-DB"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Version = "${var.deployment_version}"
    Terraform = "true"
  }
}
