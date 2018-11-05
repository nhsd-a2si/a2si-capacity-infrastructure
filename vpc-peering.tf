resource "aws_vpc_peering_connection" "vpc_peering" {
  peer_vpc_id   = "${data.aws_security_groups.postgres-client.vpc_ids.0}"
  vpc_id        = "${aws_vpc.capacity.id}"
  auto_accept   = true

  tags {
    Environment = "${var.environment}"
    Name = "CS to Postgres VPC Peering Request"
    Owner = "${var.nhs_owner}"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Terraform = "true"
  }
}

resource "aws_route" "a2si-cd-stage-cs-to-postgres-route" {
  route_table_id            = "${aws_route_table.capacity-public-rt.id}"
  destination_cidr_block    = "${var.vpc_postgres_cidr}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc_peering.id}"
}

data "aws_route_table" "a2si-cd-postgres-to-cs-route" {
  vpc_id = "${data.aws_security_groups.postgres-client.vpc_ids.0}"

  filter {
    name   = "tag:Environment"
    values = ["${var.environment}"]
  }

  filter {
    name   = "tag:Name"
    values = ["${var.capacity_public_subnet_rt}"]
  }

}

resource "aws_route" "a2si-cd-stage-postgres-to-cs-route" {
  route_table_id            = "${data.aws_route_table.a2si-cd-postgres-to-cs-route.id}"
  destination_cidr_block    =  "${var.vpc_cidr}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc_peering.id}"
}
