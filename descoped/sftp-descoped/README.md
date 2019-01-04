# a2si-capacity-infrastructure/sftp

Please follow all of the following steps before attempting to apply the TerraForm
config contained herein.

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

  1. [Setting up Terraform state backend](../docs/README.terraformstate.md)

  2. [Creating a local set of config variables](../docs/README.tfvars.md)

  3. [Setting up a bucket for Beanstalk app versions](../docs/README.beanstalkappversions.md)

  4. [Deploying the applications](../docs/README.deploying.md)

Note that the `terraform.tf` file should contain values for `bucket` and `dynamodb_table` that are both different to those in the parent folder.

After running `terraform apply`, the public key files can be copied back to your local machine using:
e.g.
`scp -i "key-pair-dev.pem" ubuntu@<sftp-ip-or-name>:/home/ubuntu/files/dhu.pem <your-path>/<your-userprofile>-dhu.pem`
`scp -i "key-pair-dev.pem" ubuntu@<sftp-ip-or-name>:/home/ubuntu/files/capacity_reader.pem <your-path>/<your-userprofile>-capacity_reader.pem`

If you want to use pre-existing key pairs then you can copy the private key into `/home/ubuntu/files` using `scp` and reversing the two
paths in the above command.
Then `ssh` into the server and copy (`cp`) the file from `/home/ubunty/files` into e.g.
`/home/dhu/.ssh/authorized_keys`
`/home/capacity_reader/.ssh/authorized_keys`