resource "aws_elastic_beanstalk_application" "capacity-service" {
  name        = "capacity-service"
  description = "Capacity Service"
}

resource "aws_elastic_beanstalk_application_version" "capacity-service-version" {
  name        = "${var.s3_capacity_service_object}"
  application = "${aws_elastic_beanstalk_application.capacity-service.name}"
  description = "Capacity Service latest version"
  bucket      = "${var.s3_app_versions_bucket}"
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
    namespace = "aws:elbv2:loadbalancer"
    name      = "SecurityGroups"
    value     = "${aws_security_group.cache-client.id},${aws_security_group.allow-8080-all.id}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "CACHE_ENDPOINT"
    value     = "${aws_elasticache_cluster.capacity-cache.cache_nodes.0.address}"
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
