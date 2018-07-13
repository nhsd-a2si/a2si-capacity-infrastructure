resource "aws_vpc" "capacity" {
  cidr_block = "${var.vpc_cidr}"

  tags = {
    Environment = "${var.environment}"
    Name = "Capacity"
    Owner = "${var.nhs_owner}"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Terraform = "true"
  }
}

resource "aws_subnet" "capacity-public-subnets" {
  vpc_id = "${aws_vpc.capacity.id}"
  count = 2
  cidr_block = "${element(var.public_subnet_cidrs, count.index)}"
  availability_zone = "${element(var.aws_azs, count.index)}"

  tags {
    Environment = "${var.environment}"
    Name = "Capacity ${element(var.aws_azs, count.index)} Public Subnet"
    Owner = "${var.nhs_owner}"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Terraform = "true"
  }
}

resource "aws_internet_gateway" "capacity-gw" {
  vpc_id = "${aws_vpc.capacity.id}"

  tags {
    Environment = "${var.environment}"
    Name = "Capacity VPC IGW"
    Owner = "${var.nhs_owner}"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Terraform = "true"
  }
}

resource "aws_route_table" "capacity-public-rt" {
  vpc_id = "${aws_vpc.capacity.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.capacity-gw.id}"
  }

  tags {
    Environment = "${var.environment}"
    Name = "Capacity Public Subnet RT"
    Owner = "${var.nhs_owner}"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Terraform = "true"
  }
}

resource "aws_route_table_association" "capacity-public-rt" {
  count = 2
  subnet_id = "${element(aws_subnet.capacity-public-subnets.*.id, count.index)}"
  route_table_id = "${aws_route_table.capacity-public-rt.id}"
}
