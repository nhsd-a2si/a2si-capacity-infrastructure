resource "aws_security_group" "allow-8080-all" {
  name        = "allow-8080-all"
  description = "Allow port 8080 from anywhere"
  vpc_id      = "${aws_vpc.capacity.id}"

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
