resource "aws_elastic_beanstalk_application" "capacity-service" {
  name        = "capacity-service"
  description = "Capacity Service"
}

resource "aws_elastic_beanstalk_application_version" "capacity-service-version" {
  name        = "${var.s3_capacity_service_object}"
  application = "${aws_elastic_beanstalk_application.capacity-service.name}"
  description = "Capacity Service current version"
  bucket      = "${data.aws_s3_bucket.eb_zip_versions_bucket.id}"
  key         = "${var.s3_capacity_service_object}"
}

resource "aws_elastic_beanstalk_environment" "capacity-service-env" {
  name                = "capacity-service-env"
  application         = "${aws_elastic_beanstalk_application.capacity-service.name}"
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

  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "true"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = "${aws_security_group.cache-client.id}"
  }
  tags {
    Environment = "${var.environment}"
    Name = "Capacity Service Env"
    Owner = "${var.nhs_owner}"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Terraform = "true"
  }
}
