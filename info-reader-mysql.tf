# Create a database server
resource "aws_db_instance" "capacity_reader_mysql" {
  engine            = "mysql"
  engine_version    = "5.6.39"
  instance_class    = "db.t2.micro"
  identifier        = "${var.nhs_owner_shortcode}${var.mysql_db_instance}"
  name              = "${var.nhs_owner_shortcode}${var.mysql_db_name}"
  username          = "${var.mysql_username}"
  password          = "${var.mysql_password}"
  port              = "3306"
  allocated_storage = 5
  storage_type      = "gp2"
  #availability_zone = ["${var.aws_azs}"]
  publicly_accessible = "false"
  skip_final_snapshot = "true"
  db_subnet_group_name   = "${aws_db_subnet_group.capacity-reader-mysql-subnet-group.name}"
  vpc_security_group_ids  = ["${aws_security_group.allow-mysql-client.id}"]

  tags {
    Environment = "${var.environment}"
    Name = "Capacity Reader MySQL Instance"
    Owner = "${var.nhs_owner}"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Terraform = "true"
  }
}

resource "aws_db_subnet_group" "capacity-reader-mysql-subnet-group" {
  name        = "${var.nhs_owner}-capacity-reader-mysql-subnet-group"
  description = "Subnet group for Capacity Reader MySQL"
  subnet_ids = ["${aws_subnet.capacity-public-subnets.*.id}"]
}


resource "aws_security_group" "mysql-client" {
  name        = "${var.nhs_owner}-mysql-client"
  description = "Instances which act as clients of mysql"
  vpc_id      = "${aws_vpc.capacity.id}"

  tags {
    Environment = "${var.environment}"
    Name = "mysql-client Security Group"
    Owner = "${var.nhs_owner}"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Terraform = "true"
  }
}

resource "aws_security_group" "allow-mysql-client" {
  name        = "${var.nhs_owner}-allow-mysql-client"
  description = "Allow connection by appointed mysql clients"
  vpc_id      = "${aws_vpc.capacity.id}"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.mysql-client.id}"]
  }

  tags {
    Environment = "${var.environment}"
    Name = "allow-mysql-client Security Group"
    Owner = "${var.nhs_owner}"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Terraform = "true"
  }
}
