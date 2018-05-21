resource "aws_elastic_beanstalk_application" "dos-wrapper" {
  name        = "dos-wrapper"
  description = "DoS Wrapper"
}

resource "aws_elastic_beanstalk_application_version" "dos-wrapper-version-latest" {
  name        = "dos-wrapper-version-latest"
  application = "${aws_elastic_beanstalk_application.dos-wrapper.name}"
  description = "Capacity Service latest version"
  bucket      = "${data.aws_s3_bucket.eb_zip_versions_bucket.id}"
  key         = "dos-wrapper-latest.zip"
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

  tags {
    Environment = "${var.environment}"
    Name = "DoS Wrapper Env"
    Owner = "${var.nhs_owner}"
    ProgrammeName = "${var.nhs_programme_name}"
    ProjectName = "${var.nhs_project_name}"
    Terraform = "true"
  }
}
