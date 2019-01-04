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
