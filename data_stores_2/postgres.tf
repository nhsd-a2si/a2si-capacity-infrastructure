# Create a postgres database server
resource "aws_db_instance" "capacity_postgres" {
  engine            = "postgres"
  engine_version    = "10.4"
  instance_class    = "db.t2.large"
  identifier        = "${var.nhs_owner_shortcode}-${var.postgres_db_instance}"
  name              = "${replace(var.nhs_owner_shortcode, "-", "")}${var.postgres_db_name}"
  username          = "${var.postgres_username}"
  password          = "${var.postgres_password}"
  port              = "5432"
  allocated_storage = 5
  storage_type      = "gp2"
  storage_encrypted = "true"
  publicly_accessible = "false"
  skip_final_snapshot = "false"
  final_snapshot_identifier = "${var.nhs_owner_shortcode}-${var.postgres_db_instance}-${replace(replace(replace(timestamp(), ":", "-"), "T", "-"), "Z", "-FINAL")}"
  backup_window = "00:00-00:30"
  backup_retention_period = "7"
  db_subnet_group_name   = "${aws_db_subnet_group.capacity-service-postgres-subnet-group.name}"
  vpc_security_group_ids  = ["${aws_security_group.allow-postgres-client.id}"]

  tags {
    Environment = "${var.environment}"
    Name = "Capacity Service Postgres Instance"
    Owner = "${var.nhs_owner}"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Terraform = "true"
  }
}

resource "aws_db_subnet_group" "capacity-service-postgres-subnet-group" {
  name        = "${var.nhs_owner_shortcode}-capacity-service-postgres-subnet-group"
  description = "Subnet group for Capacity Service Postgres"
  subnet_ids = ["${data.aws_subnet.capacity-public-subnet.*.id}"]

  tags {
    Environment = "${var.environment}"
    Owner = "${var.nhs_owner}"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Terraform = "true"
  }
}

resource "aws_security_group" "postgres-client" {
  name        = "${var.nhs_owner_shortcode}-postgres-client"
  description = "Instances which act as clients of postgres"
  vpc_id      = "${data.aws_vpc.capacity.id}"

  tags {
    Environment = "${var.environment}"
    Name = "postgres-client Security Group"
    Owner = "${var.nhs_owner}"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Terraform = "true"
  }
}

resource "aws_security_group" "allow-postgres-client" {
  name        = "${var.nhs_owner_shortcode}-allow-postgres-client"
  description = "Allow connection by appointed postgres clients"
  vpc_id      = "${data.aws_vpc.capacity.id}"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = ["${aws_security_group.postgres-client.id}"]
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Environment = "${var.environment}"
    Name = "allow-postgres-client Security Group Definition"
    Owner = "${var.nhs_owner}"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Terraform = "true"
  }
}
