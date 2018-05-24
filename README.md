# a2si-capacity-infrastructure

## CAVEAT

Currently this is knowingly naive in _at least_ the following ways:

  1. There is only a public subnet. This is bad because all the non-public facing
     services are brought up in public. Sure we can limit the silliness through
     diligent use of SecurityGroups (Note to self: TODO) but it would be nice to
     throw up a private/public architecture before beta.

  2. There is no multi AZ. This is bad for availability. It would be good to correct
     this also.

# Pre-requisites

## Create bucket for app version assets

Beanstalk will deploy app versions from an S3 bucket. That bucket needs
creating _manually_ before you can run any of the Terraform config.

(We are creating it manually so that you can upload the zipped app assets before
running the TerraForm config)

Decide on the S3 bucket name which will be used to hold the app version assets.
For these instructions this will be _S3BUCKET_.

*IMPORTANT*: You will need to remember this name in order to pass it into the
`tf apply` command later in these instructions.

Create the bucket:

    $ aws s3 mb s3://S3BUCKET

This is a once-only step. For future deployments you will not need to do this.

# Deploying the Capacity Service and DoS Wrapper applications

## Upload the zipped application assets to the S3 bucket

First upload the zip files of the versions to the S3 bucket:

    $ aws s3 cp <location of capacity service zip file> s3://S3BUCKET/capacity-service-vXXX.zip
    $ aws s3 cp <location of dos wrapper zip file> s3://S3BUCKET/dos-wrapper-vXXX.zip

Note that it is expected that you will version the S3 object names somehow. Remember
these object names because you will need them in the next step.

## Apply the Terraform

    $ terraform apply \
      --var 'capacity_service_api_username=dummyValue' \
      --var 'capacity_service_api_password=dummyValue' \
      --var 's3_app_versions_bucket=S3BUCKET' \
      --var 's3_capacity_service_object=capacity-service-vXXX.zip' \
      --var 's3_dos_wrapper_object=dos-wrapper-vXXX.zip' .

capacity_service_api_username capacity_service_api_password

In reality you can call those objects anything; they don't have to start
"capacity-service-v". All that matters are the following:

  1. You use a new, unique name each time (to ensure the version gets deployed)

  2. The names you use in the `terraform apply` step match the names you used in
     the `aws s3 cp` step immediately before it.

## A note on versioning

The Terraform uses the provided `s3_capacity_service_object` and
`s3_dos_wrapper_object` variables to _name_ the app versions. This means
that you will end up with application version names which are filename-like (e.g. ending in
`.zip`) but this seems preferable to making loads of assumptions in the
Terraform about filename formats, and similarly preferable to forcing a second
pair of 'vars' to be used to specify a neater version name.
