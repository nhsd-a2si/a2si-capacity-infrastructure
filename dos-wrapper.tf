resource "aws_elastic_beanstalk_application" "dos-wrapper" {
  name        = "dos-wrapper"
  description = "DoS Wrapper"
}

resource "aws_elastic_beanstalk_environment" "dos-wrapper-env" {
  name                = "dos-wrapper-env"
  application         = "${aws_elastic_beanstalk_application.dos-wrapper.name}"
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.10.0 running Docker 17.12.1-ce"

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "${aws_vpc.capacity.id}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${aws_subnet.capacity-public-subnet.id}"
  }

  tags {
    Environment = "${var.environment}"
    Name = "DoS Wrapper Env"
    Terraform = "true"
  }
}
