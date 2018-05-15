resource "aws_elastic_beanstalk_application" "capacity-service" {
  name        = "capacity-service"
  description = "Capacity Service"
}

resource "aws_elastic_beanstalk_environment" "capacity-service-env" {
  name                = "capacity-service-env"
  application         = "${aws_elastic_beanstalk_application.capacity-service.name}"
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
    Name = "Capacity Service Env"
    Terraform = "true"
  }
}
