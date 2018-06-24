# a2si-capacity-infrastructure

Please follow all of the following steps before attempting to apply the TerraForm
config contained herein.

## CAVEAT

Currently this is knowingly naive in _at least_ the following ways:

  1. There is only a public subnet. This is bad because all the non-public facing
     services are brought up in public. Sure we can limit the silliness through
     diligent use of SecurityGroups (Note to self: TODO) but it would be nice to
     throw up a private/public architecture before beta.

## Tools

Before you can do anything, you will need the following:

  - Sufficient permissions to apply the Terraform configuration to your AWS
    environment of choosing. Good luck.

  - The AWS Command Line Interface runtime, correctly configured to access your
    AWS environment of choosing, as the account who has the powers needed to run
    such things. Get the AWS CLI from here: https://aws.amazon.com/cli/

  - The Terraform runtime which you can get here: https://www.terraform.io/downloads.html

Please note that there are alternatives to installing these packages on your machine.
You may in particular like to look at running them as Docker containers because
cleanliness.

In the instructions contained, commands that begin `$ aws` require the AWS CLI
and commands that begin `$ terraform` require the Terraform runtime.

## Setting up this repo for development

There are a few stages required to set up this repo for your development. Please
follow each of these in turn:

  1. [Setting up Terraform state backend](docs/README.terraformstate.md)

  2. [Creating a local set of config variables](docs/README.tfvars.md)

  3. [Setting up a bucket for Beanstalk app versions](docs/README.beanstalkappversions.md)

  4. [Deploying the applications](docs/README.deploying.md)
