data "aws_vpc" "capacity" {

  filter {
    name   = "tag:Environment"
    values = ["${var.environment}"]
    }

  filter {
    name   = "tag:Name"
    values = ["Capacity VPC"]
    }
}

data "aws_vpc" "reporting" {

  filter {
    name   = "tag:Environment"
    values = ["${var.environment}"]
    }

  filter {
    name   = "tag:Name"
    values = ["Reporting VPC"]
    }
}

data "aws_subnet_ids" "reporting-public-subnet-ids" {
  vpc_id = "${data.aws_vpc.reporting.id}"
}

data "aws_subnet" "reporting-public-subnet" {
  count = "${length(data.aws_subnet_ids.reporting-public-subnet-ids.ids)}"
  id    = "${data.aws_subnet_ids.reporting-public-subnet-ids.ids[count.index]}"
}

data "aws_subnet_ids" "capacity-public-subnet-ids" {
  vpc_id = "${data.aws_vpc.capacity.id}"
}

data "aws_subnet" "capacity-public-subnet" {
  count = "${length(data.aws_subnet_ids.capacity-public-subnet-ids.ids)}"
  id    = "${data.aws_subnet_ids.capacity-public-subnet-ids.ids[count.index]}"
}

data "aws_security_groups" "cache-client-sgs" {

  filter {
    name   = "vpc-id"
    values = ["${data.aws_vpc.capacity.id}"]
  }

  filter {
    name   = "tag:Name"
    values = ["cache-client Security Group"]
    }
}

data "aws_security_group" "cache-client-sg" {
  id = "${data.aws_security_groups.cache-client-sgs.ids[0]}"
}

data "aws_iam_instance_profile" "a2si-eb" {
  name = "${var.nhs_owner_shortcode}-a2si-elasticbeanstalk-ec2-role"
}

data "aws_elasticache_replication_group" "capacity-cache" {
  replication_group_id = "${var.nhs_owner_shortcode}-cc-gp"
}

data "aws_security_groups" "postgres-client-sgs" {

  filter {
    name   = "vpc-id"
    values = ["${data.aws_vpc.reporting.id}"]
  }

  filter {
    name   = "tag:Name"
    values = ["postgres-client Security Group"]
    }
}

data "aws_security_group" "postgres-client-sg" {
  id = "${data.aws_security_groups.postgres-client-sgs.ids[0]}"
}

data "aws_db_instance" "capacity_postgres" {
  db_instance_identifier        = "${var.nhs_owner_shortcode}-${var.postgres_db_instance}"
}
