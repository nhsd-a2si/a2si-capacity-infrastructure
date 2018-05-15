resource "aws_elastic_beanstalk_application" "dos-wrapper" {
  name        = "dos-wrapper"
  description = "DoS Wrapper"
}

resource "aws_elastic_beanstalk_environment" "dos-wrapper-env" {
  name                = "dos-wrapper-env"
  application         = "${aws_elastic_beanstalk_application.dos-wrapper.name}"
  solution_stack_name = "${data.aws_elastic_beanstalk_solution_stack.single_docker.name}"

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
