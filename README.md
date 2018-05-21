# a2si-capacity-infrastructure

# Pre-requisites

## Create bucket for app version assets

Beanstalk will deploy app versions from an S3 bucket. That bucket needs
creating _manually_ before you can run any of the Terraform config.

(We are creating it manually so that you can upload the zipped app assets before
running the TerraForm config)

Decide on the S3 bucket name which will be used to hold the app version assets.
For these instructions this will be _S3BUCKET_.

*IMPORTANT*: This name will need to match the value of the TF variable "s3_app_versions_bucket"
(whose default is set in `variables.tf`)

Create the bucket:

  $ aws s3 mb s3://S3BUCKET

# Deploying the Capacity Service application

## Upload the zipped application assets to the S3 bucket

  $ aws s3 cp <location of zip file> s3://S3BUCKET/capacity-service-latest.zip

# Deploying the DoS Wrapper application

## Upload the zipped application assets to the S3 bucket

  $ aws s3 cp <location of zip file> s3://S3BUCKET/dos-wrapper-latest.zip
