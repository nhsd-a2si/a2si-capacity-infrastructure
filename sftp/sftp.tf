# Create an SFTP server

# Create EC2 Ubuntu instance to install SFTP onto
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "sftpserver" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  key_name      = "${aws_key_pair.key-pair-dev.id}"
  subnet_id     = "${element(aws_subnet.capacity-public-subnets.*.id, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.sftp-sg.id}"]
  associate_public_ip_address = true

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = "${file("key-pair-dev.pem")}"
    }

    script = "sftp_configure.sh"
#    inline = [
#      "sudo apt-get update -y",
#      "sudo apt-get install vsftpd",
#      "sudo mkdir /sftp",
#      "sudo chmod 755 /sftp",
#      "sudo groupadd sftpusers",
#      "sudo sed -e '/Subsystem sftp \\/usr\\/lib\\/openssh\\/sftp-server/ s/^#*/#/' -i /etc/ssh/sshd_config",
#      "sudo echo 'Subsystem sftp internal-sftp' >> /etc/ssh/sshd_config",
#      "sudo echo 'Match group sftpusers' >> /etc/ssh/sshd_config",
#      "sudo echo 'ChrootDirectory /sftp/' >> /etc/ssh/sshd_config",
#      "sudo echo 'X11Forwarding no' >> /etc/ssh/sshd_config",
#      "sudo echo 'AllowTcpForwarding no' >> /etc/ssh/sshd_config",
#      "sudo echo 'ForceCommand internal-sftp' >> /etc/ssh/sshd_config",
#      "sudo /etc/init.d/ssh restart",
#      "exit"
#    ]
  }

  tags {
    Environment = "${var.environment}"
    Name = "${var.nhs_owner_shortcode}-SFTP Server"
    Owner = "${var.nhs_owner}"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Terraform = "true"
  }

}


resource "aws_security_group" "sftp-sg" {
  name   = "${var.nhs_owner_shortcode}-sftp-security-group"
  vpc_id = "${aws_vpc.capacity.id}"

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
