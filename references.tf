data "aws_db_instance" "capacity_postgres" {
  db_instance_identifier        = "${var.nhs_owner_shortcode}-${var.postgres_db_instance}"
}

data "aws_security_groups" "postgres-client" {
  filter {
    name   = "group-name"
    values = ["${var.nhs_owner_shortcode}-postgres-client"]
  }

  filter {
    name   = "tag:Name"
    values = ["postgres-client Security Group"]
  }
}

resource "aws_vpc_peering_connection" "root-to-postgres" {
  peer_vpc_id   = "${data.aws_security_groups.postgres-client.vpc_ids.0}"
  vpc_id        = "${aws_vpc.capacity.id}"
  auto_accept = true


  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

