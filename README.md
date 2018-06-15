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

## Tools

You will need the following:

  - Sufficient permissions to apply the Terraform configuration to your AWS
    environment of choosing. Good luck.

  - The AWS Command Line Interface runtime, correctly configured to access your
    AWS environment of choosing, as the account who has the powers needed to run
    such things. Get the AWS CLI from here: https://aws.amazon.com/cli/

  - The Terraform runtime which you can get here: https://www.terraform.io/downloads.html

Please note that there are alternatives to installing these packages on your machine.
You may in particular like to look at running them as Docker containers because
cleanliness.

In the instructions which follow, commands that begin `$ aws` require the AWS CLI
and commands that begin `$ terraform` require the Terraform runtime.

## Customise the project Terraform state settings to match your own

  1. Copy file terraform.tf.template to location terraform.tf

  2. Change the `bucket` property to match the name of the S3 bucket in which
     you will be keeping Terraform state data.

  3. Change the `dynamodb_table` property to match the name of the DynamoDB
     table you will use for the state lock.

See file `README.tfstate.md` for details on this process.

## Create a bucket for app version assets

Beanstalk will deploy app versions from an S3 bucket. That bucket needs
creating **manually** before you can run any of the Terraform config.

*We are creating it manually so that you can upload the zipped app assets before
running the TerraForm config.*

Decide on the S3 bucket name which will be used to hold the app version assets.

For these instructions this will be `S3BUCKET`.

**IMPORTANT**: You will need to remember this name in order to pass it into the
`tf apply` command later in these instructions.

Create the bucket:

    $ aws s3 mb s3://S3BUCKET

This is a once-only step. For future deployments you will not need to do this.

# Deploying the Capacity Service and DoS Proxy applications

## Upload the zipped application assets to the S3 bucket

First upload the zip files of the versions to the S3 bucket:

    $ aws s3 cp <location of capacity service zip file> s3://S3BUCKET/capacity-service-vXXX.zip
    $ aws s3 cp <location of dos proxy zip file> s3://S3BUCKET/dos-proxy-vXXX.zip

Note that it is expected that you will version the S3 object names somehow. Remember
these object names because you will need them in the next step.

## Identify the correct sub domain

Your AWS account will need to have a Route 53 record for a domain into which
the service endpoint FQDNs and the Load Balancer certificates will be created.

This domain record **needs to exist before running these scripts**.

This value is referred to as `publicdomain.com` in the command which follows.

## Apply the Terraform

    $ terraform apply \
      --var 'public_domain=publicdomain.com'
      --var 'capacity_service_api_username=dummyValue' \
      --var 'capacity_service_api_password=dummyValue' \
      --var 's3_app_versions_bucket=S3BUCKET' \
      --var 's3_capacity_service_object=capacity-service-vXXX.zip' \
      --var 's3_dos_proxy_object=dos-proxy-vXXX.zip' .

In reality you can call those objects anything; they don't have to start
"capacity-service-v". All that matters are the following:

  1. You use a new, unique name each time (to ensure the version gets deployed)

  2. The names you use in the `terraform apply` step match the names you used in
     the `aws s3 cp` step immediately before it.

### Using *.auto.tfvars files

As opposed to passing variables on the command line each time you run a `terraform ???` command, Terraform can automatically read variables in from files ending in `auto.tfvars`.

There is a `template.auto.tfvars` files containing the variables you will need to apply the Terraform configuration.
These are commented out by default and so won't be used.

1. Make a copy of `template.auto.tfvars` and call it `local.auto.tfvars`
2. Uncomment the lines in `local.auto.tfvars` and set the variables to your own values

Now when you run a `terraform ???` command, this is the equivalent of passing these variables in on the command line as `--var "variable_name=value"` 

### A note on versioning

The Terraform uses the provided `s3_capacity_service_object` and
`s3_dos_proxy_object` variables to _name_ the app versions. 

This means that you will end up with application version names which are filename-like (e.g. ending in
`.zip`) but this seems preferable to making loads of assumptions in the
Terraform about filename formats, and similarly preferable to forcing a second
pair of 'vars' to be used to specify a neater version name.

## Getting Elastic Beanstalk to adopt the new application

Performing the above will not actually get Elastic Beanstalk to _run_ the version
you uploaded. To get that to happen, you will need to issue the following commands.

Below you will need to identify the correct values for the `environment_name` and `application-name` variables.
These names will be the below example values (e.g. **capacity-service-env**) prefixed with the `environment` value.

e.g. if your `environment` value is **dev** the `application-name` will be **dev-capacity-service** and the `environment_name` will be **dev-capacity-service-env** 

### To update the Capacity Service environment

    $ aws elasticbeanstalk update-environment \
      --application-name capacity-service \
      --environment-name capacity-service-env \
      --version-label capacity-service-vXXX.zip

### To update the DoS Proxy environment

    $ aws elasticbeanstalk update-environment \
      --application-name dos-proxy \
      --environment-name dos-proxy-env \
      --version-label dos-proxy-vXXX.zip
