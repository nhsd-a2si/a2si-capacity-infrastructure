resource "aws_elastic_beanstalk_application" "dos-wrapper" {
  name        = "${var.environment}-dos-proxy"
  description = "DoS Wrapper"
}

resource "aws_elastic_beanstalk_configuration_template" "dos-wrapper-config-template" {
  name                = "dos-wrapper-config-template"
  application         = "${aws_elastic_beanstalk_application.dos-wrapper.name}"
  solution_stack_name = "${data.aws_elastic_beanstalk_solution_stack.single_docker.name}"
}

resource "aws_elastic_beanstalk_application_version" "dos-wrapper-version" {
  name        = "${var.s3_dos_proxy_object}"
  application = "${aws_elastic_beanstalk_application.dos-wrapper.name}"
  description = "DoS Wrapper current version"
  bucket      = "${data.aws_s3_bucket.eb_zip_versions_bucket.id}"
  key         = "${var.s3_dos_proxy_object}"
}

resource "aws_elastic_beanstalk_environment" "dos-wrapper-env" {
  name                = "${var.environment}-dos-proxy-env"
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
    value     = "${join(",", aws_subnet.capacity-public-subnets.*.id)}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = "${join(",", aws_subnet.capacity-public-subnets.*.id)}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "true"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name = "Availability Zones"
    value = "Any ${length(var.aws_azs)}"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "MeasureName"
    value     = "CPUUtilization"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Statistic"
    value     = "Average"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Unit"
    value     = "Percent"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "UpperThreshold"
    value     = "80"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "UpperBreachScaleIncrement"
    value     = "1"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "LowerThreshold"
    value     = "40"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "LowerBreachScaleIncrement"
    value     = "-1"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "BreachDuration"
    value     = "2"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Period"
    value     = "2"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name = "MinSize"
    value = "1"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name = "MaxSize"
    value = "4"
  }

  setting {
    namespace = "aws:elb:listener"
    name = "ListenerEnabled"
    value = "false"
  }

  setting {
    namespace = "aws:elb:listener:443"
    name = "ListenerProtocol"
    value = "HTTPS"
  }

  setting {
    namespace = "aws:elb:listener:443"
    name = "SSLCertificateId"
    value = "${aws_acm_certificate_validation.dos-wrapper-lb.certificate_arn}"
  }

  setting {
    namespace = "aws:elb:listener:443"
    name = "InstancePort"
    value = "80"
  }

  setting {
    namespace = "aws:elb:listener:443"
    name = "InstanceProtocol"
    value = "HTTP"
  }

  # ENV vars for the service
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SPRING_PROFILES_ACTIVE"
    value     = "${var.dos_proxy_spring_profiles_active}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "CAPACITY_SERVICE_CLIENT_API_URL"
    value     = "https://${aws_route53_record.capacity-service-lb.fqdn}/capacity"
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
    Owner = "${var.nhs_owner}"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Terraform = "true"
  }
}
