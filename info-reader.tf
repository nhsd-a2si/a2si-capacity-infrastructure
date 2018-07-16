resource "aws_elastic_beanstalk_application" "info-reader" {
  name = "${var.nhs_owner_shortcode}-info-reader"
  description = "Info Reader"
}

output "info-reader-application" {
  value = "${aws_elastic_beanstalk_application.info-reader.name}"
}

resource "aws_elastic_beanstalk_configuration_template" "info-reader-config-template" {
  name = "${var.nhs_owner_shortcode}-info-reader-config-template"
  application = "${aws_elastic_beanstalk_application.info-reader.name}"
  solution_stack_name = "${data.aws_elastic_beanstalk_solution_stack.single_docker.name}"
}

resource "aws_elastic_beanstalk_application_version" "info-reader-version" {
  name = "${var.s3_info_reader_object}"
  application = "${aws_elastic_beanstalk_application.info-reader.name}"
  description = "info Reader current version"
  bucket = "${data.aws_s3_bucket.eb_zip_versions_bucket.id}"
  key = "${var.s3_info_reader_object}"
}

resource "aws_elastic_beanstalk_environment" "info-reader-env" {
  name = "${var.nhs_owner_shortcode}-info-reader-env"
  application = "${aws_elastic_beanstalk_application.info-reader.name}"
  solution_stack_name = "${data.aws_elastic_beanstalk_solution_stack.single_docker.name}"

  setting {
    namespace = "aws:ec2:vpc"
    name = "VPCId"
    value = "${aws_vpc.capacity.id}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name = "Subnets"
    value = "${join(",", aws_subnet.capacity-public-subnets.*.id)}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name = "ELBSubnets"
    value = "${join(",", aws_subnet.capacity-public-subnets.*.id)}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name = "AssociatePublicIpAddress"
    value = "true"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "SecurityGroups"
    value = "${aws_security_group.mysql-client.id}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "IamInstanceProfile"
    value = "${aws_iam_instance_profile.a2si-eb.name}"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name = "Availability Zones"
    value = "Any ${length(var.aws_azs)}"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name = "MeasureName"
    value = "CPUUtilization"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name = "Statistic"
    value = "Average"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name = "Unit"
    value = "Percent"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name = "UpperThreshold"
    value = "80"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name = "UpperBreachScaleIncrement"
    value = "1"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name = "LowerThreshold"
    value = "40"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name = "LowerBreachScaleIncrement"
    value = "-1"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name = "BreachDuration"
    value = "2"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name = "Period"
    value = "2"
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
    name = "Application Healthcheck URL"
    value = "HTTPS:443/${var.healthcheck_url}"
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
    value = "${aws_acm_certificate_validation.info-reader-lb.certificate_arn}"
  }

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
    name = "SERVER_SSL_ENABLED"
    value = "true"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "SPRING_PROFILES_ACTIVE"
    value = "${var.info_reader_spring_profiles_active}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SPRING_DATASOURCE_URL"
    value     = "jdbc:mysql://${aws_db_instance.capacity_reader_mysql.endpoint}/${aws_db_instance.capacity_reader_mysql.name}?autoReconnect=true&useSSL=false"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "SPRING_DATASOURCE_USERNAME"
    value = "${var.mysql_username}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "SPRING_DATASOURCE_PASSWORD"
    value = "${var.mysql_password}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "DHUFTPJOB_REPEATINTERVAL"
    value = "${var.info_reader_dhuftpjob_repeatinterval}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "DHUFTPJOB_FTPSERVER"
    value = "${var.sftp_fq_domain_name}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "DHUFTPJOB_FTPPORT"
    value = "${var.info_reader_dhuftpjob_ftpport}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "DHUFTPJOB_FTPUSERNAME"
    value = "${var.info_reader_dhuftpjob_ftpusername}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "DHUFTPJOB_PRIVATEKEYFILENAME"
    value = "${var.info_reader_dhuftpjob_privatekeyfile}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "EKHUFTAPIJOB_REPEATINTERVAL"
    value = "${var.info_reader_ekhuftpaijob_repeatinterval}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "EKHUFTAPIJOB_APIURL"
    value = "${var.info_reader_ekhuftpaijob_apiurl}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "CAPACITY_SERVICE_CLIENT_API_URL"
    value = "https://${aws_route53_record.capacity-service-lb.fqdn}/capacity"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "CAPACITY_SERVICE_CLIENT_API_USERNAME"
    value = "${var.capacity_service_api_username}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "CAPACITY_SERVICE_CLIENT_API_PASSWORD"
    value = "${var.capacity_service_api_password}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "EC2KeyName"
    value = "${aws_key_pair.key-pair-dev.id}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name = "SystemType"
    value = "enhanced"
  }

  tags {
    Environment = "${var.environment}"
    Owner = "${var.nhs_owner}"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Terraform = "true"
  }
}

output "info-reader-env" {
  value = "${aws_elastic_beanstalk_environment.info-reader-env.name}"
}
