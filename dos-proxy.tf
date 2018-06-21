resource "aws_elastic_beanstalk_application" "dos-proxy" {
  name        = "${var.nhs_owner_shortcode}-dos-proxy"
  description = "DoS Proxy"
}

output "dos-proxy-application" {
  value = "${aws_elastic_beanstalk_application.dos-proxy.name}"
}

resource "aws_elastic_beanstalk_configuration_template" "dos-proxy-config-template" {
  name                = "${var.nhs_owner}-dos-proxy-config-template"
  application         = "${aws_elastic_beanstalk_application.dos-proxy.name}"
  solution_stack_name = "${data.aws_elastic_beanstalk_solution_stack.single_docker.name}"
}

resource "aws_elastic_beanstalk_application_version" "dos-proxy-version" {
  name        = "${var.s3_dos_proxy_object}"
  application = "${aws_elastic_beanstalk_application.dos-proxy.name}"
  description = "DoS Proxy current version"
  bucket      = "${data.aws_s3_bucket.eb_zip_versions_bucket.id}"
  key         = "${var.s3_dos_proxy_object}"
}

resource "aws_elastic_beanstalk_environment" "dos-proxy-env" {
  name                = "${var.nhs_owner_shortcode}-dos-proxy-env"
  application         = "${aws_elastic_beanstalk_application.dos-proxy.name}"
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
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "${aws_iam_instance_profile.a2si-eb.name}"
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
    namespace = "aws:elasticbeanstalk:application"
    name      = "Application Healthcheck URL"
    value     = "${var.healthcheck_url}"
  }

#  setting {
#    namespace = "aws:elb:listener"
#    name = "ListenerEnabled"
#    value = "false"
#  }

  setting {
    namespace = "aws:elb:listener:443"
    name = "ListenerProtocol"
    value = "HTTPS"
  }

  setting {
    namespace = "aws:elb:listener:443"
    name = "SSLCertificateId"
    value = "${aws_acm_certificate_validation.dos-proxy-lb.certificate_arn}"
  }

  #  For encrypting between Load Balancer and application
  #  setting {
  #    namespace = "aws:elb:listener:443"
  #    name = "InstancePort"
  #    value = "443"
  #  }

  #  setting {
  #    namespace = "aws:elb:listener:443"
  #    name = "InstanceProtocol"
  #    value = "HTTPS"
  #  }

  #  For NOT encrypting between Load Balancer and application
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

#  For NOT encrypting between Load Balancer and application
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SERVER_SSL_ENABLED"
    value     = "false"
  }
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

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "EC2KeyName"
    value = "${aws_key_pair.key-pair-dev.id}"
  }

  tags {
    Environment = "${var.environment}"
    Owner = "${var.nhs_owner}"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Terraform = "true"
  }
}

output "dos-proxy-env" {
  value = "${aws_elastic_beanstalk_environment.dos-proxy-env.name}"
}
