# a2si-capacity-infrastructure

## CAVEAT

Currently this is knowingly naive in _at least_ the following ways:

  1. It doesn't support actual Beanstalk versioning. This is a really quick,
     dirty set of Terraform scripts devised to support a beta implementation.

  2. There is only a public subnet. This is bad because all the non-public facing
     services are brought up in public. Sure we can limit the silliness through
     diligent use of SecurityGroups (Note to self: TODO) but it would be nice to
     throw up a private/public architecture before beta.

  3. There is no multi AZ. This is bad for availability. It would be good to correct
     this also.

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

# Deploying the Capacity Service and DoS Wrapper applications

## Upload the zipped application assets to the S3 bucket

First upload the zip files of the latest versions to the S3 bucket:

  $ aws s3 cp <location of capacity service zip file> s3://S3BUCKET/capacity-service-latest.zip
  $ aws s3 cp <location of dos wrapper zip file> s3://S3BUCKET/dos-wrapper-latest.zip

## Apply the Terraform

As you might expect:

$ terraform apply
