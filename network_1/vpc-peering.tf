resource "aws_vpc_peering_connection" "vpc_peering" {
  peer_vpc_id   = "${aws_vpc.reporting.id}"
  vpc_id        = "${aws_vpc.capacity.id}"
  auto_accept   = true

   accepter {
     allow_remote_vpc_dns_resolution = true
   }

   requester {
     allow_remote_vpc_dns_resolution = true
   }

  tags {
    Environment = "${var.environment}"
    Name = "CS to Reporting VPC Peering Request"
    Owner = "${var.nhs_owner}"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Terraform = "true"
  }
}

resource "aws_route" "cs-to-reporting-route" {
  route_table_id            = "${aws_route_table.capacity-public-rt.id}"
  destination_cidr_block    = "${var.vpc_reporting_cidr}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc_peering.id}"
}

resource "aws_route" "reporting-to-cs-route" {
  route_table_id            = "${aws_route_table.reporting-public-rt.id}"
  destination_cidr_block    =  "${var.vpc_cidr}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc_peering.id}"
}
