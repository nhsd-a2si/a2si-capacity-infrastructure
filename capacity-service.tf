resource "aws_elastic_beanstalk_application" "capacity-service" {
  name        = "${var.nhs_owner_shortcode}-capacity-service"
  description = "Capacity Service"
}

output "capacity-service-application" {
  value = "${aws_elastic_beanstalk_application.capacity-service.name}"
}

resource "aws_elastic_beanstalk_configuration_template" "capacity-service-config-template" {
  name                = "${var.nhs_owner_shortcode}-capacity-service-config-template"
  application         = "${aws_elastic_beanstalk_application.capacity-service.name}"
  solution_stack_name = "${data.aws_elastic_beanstalk_solution_stack.single_docker.name}"
}

resource "aws_elastic_beanstalk_application_version" "capacity-service-version" {
  name        = "${var.s3_capacity_service_object}"
  application = "${aws_elastic_beanstalk_application.capacity-service.name}"
  description = "Capacity Service current version"
  bucket      = "${data.aws_s3_bucket.eb_zip_versions_bucket.id}"
  key         = "${var.s3_capacity_service_object}"
}

resource "aws_elastic_beanstalk_environment" "capacity-service-env" {
  name                = "${var.nhs_owner_shortcode}-capacity-service-env"
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
    value = "t2.medium"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    //value     = "${aws_security_group.cache-client.id}, ${data.aws_security_groups.postgres-client.ids.0}"
    value     = "${aws_security_group.cache-client.id}"
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
    value     = "HTTPS:443/${var.healthcheck_url}"
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
    namespace = "aws:elb:listener:443"
    name = "ListenerProtocol"
    value = "HTTPS"
  }

  setting {
    namespace = "aws:elb:listener:443"
    name = "SSLCertificateId"
    value = "${aws_acm_certificate_validation.capacity-service-lb.certificate_arn}"
  }

#  For encrypting between Load Balancer and application
  setting {
    namespace = "aws:elb:listener:443"
    name = "InstancePort"
    value = "443"
  }

  setting {
    namespace = "aws:elb:listener:443"
    name = "InstanceProtocol"
    value = "HTTPS"
  }


  # ENV vars for the service

#  For NOT encrypting between Load Balancer and application
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SERVER_SSL_ENABLED"
    value     = "true"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SPRING_PROFILES_ACTIVE"
    value     = "${var.capacity_service_spring_profiles_active}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SPRING_REDIS_CLUSTER_NODES"
    value     = "${aws_elasticache_replication_group.capacity-cache.configuration_endpoint_address}:6379"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "CAPACITY_SERVICE_CACHE_TIMETOLIVEINSECONDS"
    value     = "${var.capacity_service_cache_ttl_seconds}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "CAPACITY_SERVICE_DURATION_WAIT_TIME_VALID_SECONDS"
    value     = "${var.capacity_service_cache_ttl_seconds}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "REPORTING_SERVICE_API_BASE_URL"
    value     = "https://${aws_route53_record.reporting-service-lb.fqdn}:7060"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "REPORTING_SERVICE_USERNAME"
    value     = ""
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "CAPACITY_SERVICE_DURATION_WAIT_TIME_VALID_SECONDS"
    value     = "${var.capacity_service_duration_wait_time_valid_seconds}"
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

  # Basic Auth
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AMAZON_AWS_DYNAMO_TABLE"
    value     = "${var.amazon_aws_dynamo_table}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AMAZON_AWS_DYNAMO_ENDPOINT"
    value     = "${var.amazon_aws_dynamo_endpoint}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AMAZON_AWS_DYNAMO_REGION"
    value     = "${var.amazon_aws_dynamo_region}"
  }


  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AMAZON_AWS_DYNAMO_ACCESSKEY"
    value     = "${var.amazon_aws_dynamo_accesskey}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AMAZON_AWS_DYNAMO_SECRETKEY"
    value     = "${var.amazon_aws_dynamo_secretkey}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "REPORTING_SERVICE_API_BASE_URL"
    value     = "https://${aws_route53_record.reporting-service-lb.fqdn}:7060"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "REPORTING_SERVICE_USERNAME"
    value     = ""
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "REPORTING_SERVICE_PASSWORD"
    value     = ""
  }

}

output "capacity-service-env" {
  value = "${aws_elastic_beanstalk_environment.capacity-service-env.name}"
}

