#
# Terraform script for the RDS Postgres DB
#

resource "aws_db_instance" "capacity_postgres" {
  engine            = "postgres"
  engine_version    = "10.4"
  instance_class    = "${var.postgres_instance_class}"
  identifier        = "${var.environment}-${var.postgres_db_instance}"
  name              = "${replace(var.environment, "-", "")}${var.postgres_db_name}"
  username          = "${var.postgres_username}"
  password          = "${var.postgres_password}"
  port              = "5432"
  deletion_protection = true
  multi_az          = true
  allocated_storage = "${var.postgres_allocated_storage}"
  storage_type      = "gp2"
  storage_encrypted = "true"
  publicly_accessible = "false"
  skip_final_snapshot = "false"
  final_snapshot_identifier = "${var.environment}-${var.postgres_db_instance}-${replace(replace(replace(timestamp(), ":", "-"), "T", "-"), "Z", "-FINAL")}"
  backup_window = "${var.postgres_backup_window}"
  backup_retention_period = "${var.postgres_backup_retention_period}"
  db_subnet_group_name   = "${aws_db_subnet_group.capacity-service-postgres-subnet-group.name}"
  vpc_security_group_ids  = ["${aws_security_group.allow-postgres-client.id}"]

  tags {
    Environment = "${var.environment}"
    Name = "Capacity Service Postgres Instance"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Version = "${var.deployment_version}"
    Terraform = "true"
  }
}

resource "aws_db_subnet_group" "capacity-service-postgres-subnet-group" {
  name        = "${var.nhs_owner_shortcode}-capacity-service-postgres-subnet-group"
  description = "Subnet group for Capacity Service Postgres"
  subnet_ids = ["${data.aws_subnet.capacity-public-subnet.*.id}"]

  tags {
    Environment = "${var.environment}"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Version = "${var.deployment_version}"
    Terraform = "true"
  }
}

resource "aws_security_group" "postgres-client" {
  name        = "${var.nhs_owner_shortcode}-postgres-client"
  description = "Security groups which act as clients of postgres"
  vpc_id      = "${data.capacity_vpc.id}"

  tags {
    Environment = "${var.environment}"
    Name = "postgres-client Security Group"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Version = "${var.deployment_version}"
    Terraform = "true"
  }
}

resource "aws_security_group" "allow-postgres-client" {
  name        = "${var.nhs_owner_shortcode}-allow-postgres-client"
  description = "Allow connection by appointed postgres clients"
  vpc_id      = "${data.capacity_vpc.id}"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = ["${aws_security_group.postgres-client.id}"]
    cidr_blocks = ["${data.capacity_vpc.cidr_block}"]
  }

  tags {
    Environment = "${var.environment}"
    Name = "allow-postgres-client Security Group Definition"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Version = "${var.deployment_version}"
    Terraform = "true"
  }
}
