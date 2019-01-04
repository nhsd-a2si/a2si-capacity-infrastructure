resource "aws_elasticache_replication_group" "capacity-cache" {
  automatic_failover_enabled    = true
  replication_group_id          = "${var.nhs_owner_shortcode}-cc-gp"
  replication_group_description = "Capacity Cache"
  node_type                     = "cache.t2.small"
  transit_encryption_enabled    = "true"
  at_rest_encryption_enabled    = "true"
  cluster_mode {
    replicas_per_node_group     = 0
    num_node_groups             = 2
  }
  parameter_group_name          = "default.redis4.0.cluster.on"
  port                          = 6379
  subnet_group_name             = "${aws_elasticache_subnet_group.capacity-cache-subnet-group.name}"
  security_group_ids            = ["${aws_security_group.allow-cache-client.id}"]
  engine_version                = "4.0.10"

  tags {
    Environment = "${var.environment}"
    Name = "Capacity Cache"
    Owner = "${var.nhs_owner}"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Terraform = "true"
  }
}

resource "aws_elasticache_subnet_group" "capacity-cache-subnet-group" {
    name = "${var.nhs_owner_shortcode}-capacity-cache-subnet"
    description = "Subnet group for Elasticache"
    subnet_ids = ["${data.aws_subnet.capacity-public-subnet.*.id}"]
}

resource "aws_security_group" "cache-client" {
  name        = "${var.nhs_owner_shortcode}-cache-client"
  description = "Instances which act as clients of the cache"
  vpc_id      = "${data.aws_vpc.capacity.id}"

  tags {
    Environment = "${var.environment}"
    Name = "cache-client Security Group"
    Owner = "${var.nhs_owner}"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Terraform = "true"
  }
}

resource "aws_security_group" "allow-cache-client" {
  name        = "${var.nhs_owner_shortcode}-allow-cache-client"
  description = "Allow connection by appointed cache clients"
  vpc_id      = "${data.aws_vpc.capacity.id}"

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = ["${aws_security_group.cache-client.id}"]
  }

  tags {
    Environment = "${var.environment}"
    Name = "allow-cache-client Security Group"
    Owner = "${var.nhs_owner}"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Terraform = "true"
  }
}
