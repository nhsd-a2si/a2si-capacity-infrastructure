# Deploying the applications

## Uploading the app binary versions

You created a bucket for app versions in the document [Beanstalk app versions](README.beanstalkappversions.md).
You will now upload a zip file for each app to that bucket, as follows:

    $ aws s3 cp LOCATION_OF_ZIPFILE s3://YOUR_APP_VERSIONS_BUCKET_NAME/ZIPFILE_NAME

Remember the value you chose for ZIPFILE_NAME in the upload as you will need this later.

Do this step for each of the applications.

## Applying TerraForm

If you've followed all the steps laid out in [the main README](../README.md)
then you will be able to deploy the applications by using the command:

    $ terraform apply

Once this command has completed, the resources at AWS will match the setup as
specified in this config files.

Running `apply` will yield several outputs to your terminal, such as the following:

    Outputs:

    capacity-service-application = mahe7-capacity-service
    capacity-service-env = mahe7-capacity-service-env
    capacity_service_lb_fqdn = capacity-service.mahe7.a2si-sandbox.wt.dos-tools.tech
    dos-proxy-application = mahe7-dos-proxy
    dos-proxy-env = mahe7-dos-proxy-env
    dos_proxy_lb_fqdn = dos-proxy.mahe7.a2si-sandbox.wt.dos-tools.tech
    info-reader-application = mahe7-info-reader
    info-reader-env = mahe7-info-reader-env
    info_reader_lb_fqdn = info-reader.mahe7.a2si-sandbox.wt.dos-tools.tech

The `_fqdn` outputs are the public CNAME DNS entries for your applications'
endpoints. Note these as you will need them to connect to the applications once
fully deployed.

The `-application` and `-env` outputs will be needed in the following section of
these instructions.

## Deploying the app binary versions

Congratulations on applying Terraform.

However, this does not actually _deploy_ the applications. As explained in the
[Beanstalk app versions doc](docs/README.beanstalkappversions.md), the application of
Terraform merely sets up the Beanstalk app and environment resources, and hooks the
app binary files to their respective beanstalk applications. It does not actually
make the Docker containers for the app binaries and deploy them.

In order to get the app binaries deployed on the Beanstalk apps, you need to run
the `update-environment` command for each Beanstalk app. These are shown below.

*Note that you will have to perform argument substitutions depending on your
own environment* - These argument subsitutions will come from the "outputs"
described in the previous section.

### To update an Elastic Beanstalk environment

The command to get the actual uploaded app binaries running on Beanstalk is the
same for each of the three applications (DoS Proxy, Capacity Service, Info
Reader). It is as follows:

    $ aws elasticbeanstalk update-environment \
      --application-name APP_NAME \
      --environment-name ENV_NAME \
      --version-label ZIPFILE_NAME

Substitute as follows:

  - Substitute `APP_NAME` with the `-application` name from the outputs returned when you
    applied Terraform

  - Substitute `ENV_NAME` with the `-env` name from the outputs returned when you
    applied Terraform

  - Substitute `ZIPFILE_NAME` with the name you gave to the app file binary you uploaded
    to S3 in the first step on this page, "Uploading the app binary versions"

Once you've run this command for each app, you will have to wait a few minutes for
Beanstalk to adopt this new configuration.
