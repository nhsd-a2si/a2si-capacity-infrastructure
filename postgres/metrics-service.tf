resource "aws_elastic_beanstalk_application" "metrics-service" {
  name        = "${var.nhs_owner_shortcode}-metrics-service"
  description = "Metrics Service"
}

output "metrics-service-application" {
  value = "${aws_elastic_beanstalk_application.metrics-service.name}"
}

resource "aws_elastic_beanstalk_configuration_template" "metrics-service-config-template" {
  name                = "${var.nhs_owner_shortcode}-metrics-service-config-template"
  application         = "${aws_elastic_beanstalk_application.metrics-service.name}"
  solution_stack_name = "${data.aws_elastic_beanstalk_solution_stack.single_docker.name}"
}

resource "aws_elastic_beanstalk_application_version" "metrics-service-version" {
  name        = "${var.s3_metrics_service_object}"
  application = "${aws_elastic_beanstalk_application.metrics-service.name}"
  description = "Metrics Service current version"
  bucket      = "${data.aws_s3_bucket.eb_zip_versions_bucket.id}"
  key         = "${var.s3_metrics_service_object}"
}

resource "aws_elastic_beanstalk_environment" "metrics-service-env" {
  name                = "${var.nhs_owner_shortcode}-metrics-service-env"
  application         = "${aws_elastic_beanstalk_application.metrics-service.name}"
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
    name = "InstanceType"
    value = "t2.small"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "${data.aws_iam_instance_profile.a2si-eb.name}"
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
    value = "2"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name = "MaxSize"
    value = "4"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application"
    name      = "Application Healthcheck URL"
    value     = "/"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:proxy"
    name      = "ProxyServer"
    value     = "none"
  }

  setting {
    namespace = "aws:elb:listener"
    name = "ListenerEnabled"
    value = "false"
  }

  setting {
    namespace = "aws:elb:listener:80"
    name = "ListenerProtocol"
    value = "HTTP"
  }

//  setting {
//    namespace = "aws:elb:listener:80"
//    name = "SSLCertificateId"
//    value = "${aws_acm_certificate_validation.metrics-service-lb.certificate_arn}"
//  }

#  For encrypting between Load Balancer and application
  setting {
    namespace = "aws:elb:listener:80"
    name = "InstancePort"
    value = "80"
  }

  setting {
    namespace = "aws:elb:listener:80"
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
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name = "SystemType"
    value = "enhanced"
  }


  # key-pair for ssh
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

output "metrics-service-env" {
  value = "${aws_elastic_beanstalk_environment.metrics-service-env.name}"
}
