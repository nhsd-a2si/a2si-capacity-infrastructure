resource "aws_elastic_beanstalk_application" "prometheus" {
  name        = "${var.nhs_owner_shortcode}-prometheus7"
  description = "Prometheus"
}

output "prometheus" {
  value = "${aws_elastic_beanstalk_application.prometheus.name}"
}

resource "aws_elastic_beanstalk_configuration_template" "prometheus-template" {
  name                = "${var.nhs_owner_shortcode}-prometheus-template"
  application         = "${aws_elastic_beanstalk_application.prometheus.name}"
  #solution_stack_name = "64bit Amazon Linux 2018.03 v2.11.0 running Multi-container Docker 18.03.1-ce (Generic)"
  solution_stack_name = "${data.aws_elastic_beanstalk_solution_stack.single_docker.name}"
}

resource "aws_elastic_beanstalk_application_version" "prometheus-version" {
  name        = "Dockerrun.aws.json"
  application = "${aws_elastic_beanstalk_application.prometheus.name}"
  description = "Prometheus current version"
  bucket      = "${data.aws_s3_bucket.eb_zip_versions_bucket.id}"
  key         = "Dockerrun.aws.json"
}

resource "aws_elastic_beanstalk_environment" "prometheus-env" {
  name                = "${var.nhs_owner_shortcode}-prometheus-env"
  application         = "${aws_elastic_beanstalk_application.prometheus.name}"
  #solution_stack_name = "64bit Amazon Linux 2018.03 v2.11.0 running Multi-container Docker 18.03.1-ce (Generic)"
  solution_stack_name = "${data.aws_elastic_beanstalk_solution_stack.single_docker.name}"
  wait_for_ready_timeout = "10m"

#setting {
#  namespace = "aws:ec2:vpc"
#  name = "VPCId"
#  value = "${aws_vpc.capacity.id}"
#}

#setting {
#  namespace = "aws:ec2:vpc"
#  name = "Subnets"
#  value = "${join(",", aws_subnet.capacity-public-subnets.*.id)}"
#}

#setting {
#  namespace = "aws:ec2:vpc"
#  name = "ELBSubnets"
#  value = "${join(",", aws_subnet.capacity-public-subnets.*.id)}"
#}

#setting {
#  namespace = "aws:ec2:vpc"
#  name = "AssociatePublicIpAddress"
#  value = "true"
#}

#setting {
#  namespace = "aws:autoscaling:launchconfiguration"
#  name = "IamInstanceProfile"
#  value = "${aws_iam_instance_profile.a2si-eb.name}"
#}

#setting {
#  namespace = "aws:autoscaling:asg"
#  name = "Availability Zones"
#  value = "Any ${length(var.aws_azs)}"
#}


setting {
  namespace = "aws:autoscaling:launchconfiguration"
  name = "EC2KeyName"
  value = "${aws_key_pair.key-pair-dev.id}"
}
}

output "prometheus-env" {
  value = "${aws_elastic_beanstalk_environment.prometheus-env.name}"
}

# Prometheus security group

resource "aws_security_group" "prometheus-sg" {
  name        = "${var.nhs_owner_shortcode}-prometheus-sg"
  description = "Security group for access to Prometheus"
  vpc_id      = "${aws_vpc.capacity.id}"

  tags {
    Environment = "${var.environment}"
    Name = "Prometheus Security Group"
    Owner = "${var.nhs_owner}"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Terraform = "true"
  }
}

resource "aws_security_group" "allow-prometheus-sg" {
  name        = "${var.nhs_owner_shortcode}-allow-prometheus-sg"
  description = "Allow connection to Prometheus"
  vpc_id      = "${aws_vpc.capacity.id}"

  ingress {
    from_port       = 9090
    to_port         = 9090
    protocol        = "tcp"
    security_groups = ["${aws_security_group.prometheus-sg.id}"]
  }

  tags {
    Environment = "${var.environment}"
    Name = "allow-prometheus-sg Security Group"
    Owner = "${var.nhs_owner}"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Terraform = "true"
  }
}
