# Setting up your local Terraform / AWS variables

If several engineers are working in the same AWS account, we need to make sure that
their Terraform endeavours do not collide or interfere with each other.

We achieve that by having a set of variables which are specific to each engineer.
These will be used to derive names for items which must be unique in the AWS
account, such as:

  - CNAME DNS entries

  - Subnet group names

  - RDS instance names

In the repo checkout, there is a file called _auto.tfvars.template_. Copy this file
to filename _local.auto.tfvars_. Git has been configured to ignore this file so you
may edit it without dirtying your working copy.

Go through that new file and follow the instructions therein, to set up your own
set of unique variables for applying Terraform.
