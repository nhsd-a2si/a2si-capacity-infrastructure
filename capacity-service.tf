resource "aws_elastic_beanstalk_application" "capacity-service" {
  name        = "capacity-service"
  description = "Capacity Service"
}

resource "aws_elastic_beanstalk_configuration_template" "capacity-service-config-template" {
  name                = "capacity-service-config-template"
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

  # ENV vars for the service
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
    name      = "CAPACITY_SERVICE_API_USERNAME"
    value     = "${var.capacity_service_api_username}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "CAPACITY_SERVICE_API_PASSWORD"
    value     = "${var.capacity_service_api_password}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "CAPACITY_SERVICE_CACHE_TIMETOLIVEINSECONDS"
    value     = "${var.capacity_service_cache_ttl_seconds}"
  }

  tags {
    Environment = "${var.environment}"
    Owner = "${var.nhs_owner}"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Terraform = "true"
  }
}
