#
# Lookups for the subnets within the VPC.
#
data "aws_vpc" "capacity_vpc" {
  vpc_id = "${var.capacity_vpc}"
}

data "aws_subnet_ids" "capacity-public-subnet-ids" {
  vpc_id = "${data.capacity_vpc.id}"
}

data "aws_subnet" "capacity-public-subnet" {
  count = "${length(data.aws_subnet_ids.capacity-public-subnet-ids.ids)}"
  id    = "${data.aws_subnet_ids.capacity-public-subnet-ids.ids[count.index]}"
}
