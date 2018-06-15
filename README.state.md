# Terraform State Data

Terraform requires a location to store state data. It's recommended on this
project to use the S3 backend to do this. See here for details:
https://www.terraform.io/docs/backends/types/s3.html

To enable this *for development purposes*, there are 4 steps:

  1. Create your own S3 bucket for storing state data, e.g:

  $ aws s3 mb s3://NAME_OF_BUCKET

  Choose your own NAME_OF_BUCKET

  2. Create your own DynamoDB table for storing lock record, e.g.:

  $ aws dynamodb create-table --table-name=NAME_OF_TABLE --attribute-definitions="AttributeName=LockID,AttributeType=S" --key-schema="AttributeName=LockID,KeyType=HASH" --provisioned-throughput="ReadCapacityUnits=1,WriteCapacityUnits=1"

  3. Copy file `terraform.tf.template` to location `terraform.tf`

  4. Edit the contents of new file `terraform.tf` such that the `bucket`
     and `dynamodb_table` values match the values you chose in steps 1 and 2
     above.
