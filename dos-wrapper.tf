resource "aws_elastic_beanstalk_application" "dos-wrapper" {
  name        = "dos-wrapper"
  description = "DoS Wrapper"
}

resource "aws_elastic_beanstalk_configuration_template" "dos-wrapper-config-template" {
  name                = "dos-wrapper-config-template"
  application         = "${aws_elastic_beanstalk_application.dos-wrapper.name}"
  solution_stack_name = "${data.aws_elastic_beanstalk_solution_stack.single_docker.name}"
}

resource "aws_elastic_beanstalk_application_version" "dos-wrapper-version" {
  name        = "${var.s3_dos_wrapper_object}"
  application = "${aws_elastic_beanstalk_application.dos-wrapper.name}"
  description = "DoS Wrapper current version"
  bucket      = "${data.aws_s3_bucket.eb_zip_versions_bucket.id}"
  key         = "${var.s3_dos_wrapper_object}"
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

  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "true"
  }

  # ENV vars for the service
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SPRING_PROFILES_ACTIVE"
    value     = "${var.dos_wrapper_spring_profiles_active}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "CAPACITY_SERVICE_CLIENT_API_URL"
    # TODO: Stop hardcoding the protocol and path stub if poss
    value     = "http://${aws_elastic_beanstalk_environment.capacity-service-env.cname}/capacity"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "CAPACITY_SERVICE_CLIENT_API_USERNAME"
    value     = "${var.capacity_service_api_username}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "CAPACITY_SERVICE_CLIENT_API_PASSWORD"
    value     = "${var.capacity_service_api_password}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DOS_SERVICE_URL"
    value     = "${var.dos_service_url}"
  }

  tags {
    Environment = "${var.environment}"
    Name = "DoS Wrapper Env"
    Owner = "${var.nhs_owner}"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Terraform = "true"
  }
}
