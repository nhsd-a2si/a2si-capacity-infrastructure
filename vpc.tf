resource "aws_vpc" "capacity" {
  cidr_block = "${var.vpc_cidr}"

  tags = {
    Environment = "${var.environment}"
    Name = "Capacity"
    Terraform = "true"
  }
}

resource "aws_subnet" "capacity-public-subnet" {
  vpc_id = "${aws_vpc.capacity.id}"
  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "${var.aws_az}"
  map_public_ip_on_launch = true

  tags {
    Environment = "${var.environment}"
    Name = "Capacity Public Subnet"
    Terraform = "true"
  }
}

resource "aws_internet_gateway" "capacity-gw" {
  vpc_id = "${aws_vpc.capacity.id}"

  tags {
    Environment = "${var.environment}"
    Name = "Capacity VPC IGW"
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
    Terraform = "true"
  }
}

resource "aws_route_table_association" "capacity-public-rt" {
  subnet_id = "${aws_subnet.capacity-public-subnet.id}"
  route_table_id = "${aws_route_table.capacity-public-rt.id}"
}
