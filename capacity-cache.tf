resource "aws_elasticache_cluster" "capacity-cache" {
  cluster_id           = "capacity-cache"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  port                 = 6379
  subnet_group_name    = "${aws_elasticache_subnet_group.capacity-cache-subnet-group.name}"

  tags {
    Environment = "${var.environment}"
    Name = "Capacity Cache"
    Owner = "${var.nhs_owner}"
    ProgrammeName = "${var.nhs_programme_name}"
    ProjectName = "${var.nhs_project_name}"
    Terraform = "true"
  }
}

resource "aws_elasticache_subnet_group" "capacity-cache-subnet-group" {
    name = "capacity-cache-subnet"
    description = "Subnet group for Elasticache"
    subnet_ids = ["${aws_subnet.capacity-public-subnet.id}"]
}
