# Setting up the S3 backend for Terraform

If you are developing against this code base you will need an S3 backend set up.
This holds the Terraform state, which you will care about because it's the only
link between your pretty Terraform code and the swamp of resources that get created
for you at AWS.

## Copy the template terraform.tf file

Copy the supplied file terraform.tf.template into the location terraform.tf. You
will then populate it with the AWS assets you are about to set up for your
Terraform S3 backend.

## Set up the S3 bucket for your Terraform state

This is where Terraform will persist the mappings between your TF code here and
the real-world resources created in AWS.

  1. Decide on a reasonable (unique) bucket name and create that bucket:

    $ aws s3 mb s3://YOUR_STATE_BUCKET_NAME

  2. Edit the newly-created terraform.tf file and alter the `bucket` property to
     match whatever you supplied for YOUR_STATE_BUCKET_NAME above.

## Set up the DynamoDB table for your Terraform state lock record

This is where Terraform will manage the lock file to stop concurrent alterations
of both your state data and your AWS resources.

  1. Decide on a reasonable DynamoDB table name and create that table:

    $ aws dynamodb create-table \
        --table-name=YOUR_DYNAMODB_TABLE_NAME \
        --attribute-definitions="AttributeName=LockID,AttributeType=S" \ --key-schema="AttributeName=LockID,KeyType=HASH" \ --provisioned-throughput="ReadCapacityUnits=1,WriteCapacityUnits=1"

  2. Edit the newly-created terraform.tf file and alter the `dynamodb_table` property to
     match whatever you supplied for YOUR_DYNAMODB_TABLE_NAME above.

## Verify the backend setup

Run the command:

    $ terraform init

You ought to see messages like this:

```
Initializing the backend...

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.
```
