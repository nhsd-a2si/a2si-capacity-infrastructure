resource "aws_eip" "sftp-elastic-ip" {
  instance = "${aws_instance.sftpserver.id}"
  vpc = "true"

  tags {
    Environment = "${var.environment}"
    Name = "${var.nhs_owner_shortcode}-SFTP Server Elastic IP"
    Owner = "${var.nhs_owner}"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Terraform = "true"
  }

}
