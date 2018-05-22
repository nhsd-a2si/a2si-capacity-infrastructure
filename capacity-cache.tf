resource "aws_elasticache_cluster" "capacity-cache" {
  cluster_id           = "capacity-cache"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  port                 = 6379
  subnet_group_name    = "${aws_elasticache_subnet_group.capacity-cache-subnet-group.name}"
  security_group_ids   = ["${aws_security_group.allow-cache-client.id}"]

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
    name = "capacity-cache-subnet"
    description = "Subnet group for Elasticache"
    subnet_ids = ["${aws_subnet.capacity-public-subnet.id}"]
}

resource "aws_security_group" "cache-client" {
  name        = "cache-client"
  description = "Instances which act as clients of the cache"
  vpc_id      = "${aws_vpc.capacity.id}"
}

resource "aws_security_group" "allow-cache-client" {
  name        = "allow-cache-client"
  description = "Allow connection by appointed cache clients"
  vpc_id      = "${aws_vpc.capacity.id}"

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
