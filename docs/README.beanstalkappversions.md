# Beanstalk app versions

## Beanstalk resource structure

When you successfully apply the Terraform code, it will create for you (among
other things) the following resources:

  - A Beanstalk "app" for each of the services - this is in effect just a
    placeholder for the service name

  - A Beanstalk "environment" for the app in each of the services - this is a
    set of configuration instructions to apply to each of the instances which
    will be brought up to run the service for each app

  - A Beanstalk "app version" - this is nothing more than a reference pointer
    from an app to some kind of binary asset which contains code to run "as"
    that app

We don't want to store the actual service software assets in this repo; that would
be bad. So instead we will pre-load the assets into an S3 bucket and use Terraform
to create the "app version" pointer as described above, to link the asset to the
Beanstalk app.

## Creating the S3 bucket for Beanstalk app versions

  1. Decide on the S3 bucket name which will be used to hold the app version assets
     for _your_ Terraform work, then create that bucket:

     `$ aws s3 mb s3://YOUR_APP_VERSIONS_BUCKET_NAME`

   2. Edit your _local.auto.tfvars_ file and alter the `s3_app_versions_bucket`
      property to match whatever you supplied for YOUR_APP_VERSIONS_BUCKET_NAME above.
      If you don't have a _local.auto.tfvars_ file then it means you skipped the setup
      step outlined in this doc: [Creating a local set of config variables](./README.tfvars.md)

This is a once-only step.
