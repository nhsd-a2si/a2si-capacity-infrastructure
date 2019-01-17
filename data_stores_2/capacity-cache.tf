#
# Elasticache terraform script defining elasticache and security groups
#

resource "aws_elasticache_replication_group" "capacity-cache" {
  replication_group_id          = "${var.environment}-cc-gp"
  replication_group_description = "Capacity Cache"
  node_type                     = "${var.elasticache_node_type}"
  transit_encryption_enabled    = "true"
  at_rest_encryption_enabled    = "true"
  availability_zones            = ["${var.aws_azs}"]
  automatic_failover_enabled    = true
  cluster_mode {
    replicas_per_node_group     = "${var.elasticache_cluster_mode_replicas_per_node_group}"
    num_node_groups             = "${var.elasticache_cluster_mode_num_node_groups}"
  }
  parameter_group_name          = "default.redis4.0.cluster.on"
  port                          = 6379
  subnet_group_name             = "${aws_elasticache_subnet_group.capacity-cache-subnet-group.name}"
  security_group_ids            = ["${aws_security_group.allow-cache-client.id}"]
  engine_version                = "4.0.10"

  tags {
    Environment = "${var.environment}"
    Name = "Capacity Cache"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Version = "${var.deployment_version}"
    Terraform = "true"
  }
}

resource "aws_elasticache_subnet_group" "capacity-cache-subnet-group" {
    name = "${var.environment}-capacity-cache-subnet"
    description = "Subnet group for Elasticache"
    subnet_ids = ["${data.aws_subnet.capacity-public-subnet.*.id}"]
}

resource "aws_security_group" "cache-client" {
  name        = "${var.environment}-cache-client"
  description = "Instances which act as clients of the cache"
  vpc_id      = "${data.capacity_vpc.id}"

  tags {
    Environment = "${var.environment}"
    Name = "cache-client Security Group"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Version = "${var.deployment_version}"
    Terraform = "true"
  }
}

resource "aws_security_group" "allow-cache-client" {
  name        = "${var.environment}-allow-cache-client"
  description = "Allow connection by appointed cache clients"
  vpc_id      = "${data.capacity_vpc.id}"

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = ["${aws_security_group.cache-client.id}"]
    cidr_blocks = ["${data.capacity_vpc.cidr_block}"]
  }

  tags {
    Environment = "${var.environment}"
    Name = "Security Group for access to elasticache"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Version = "${var.deployment_version}"
    Terraform = "true"
  }
}
