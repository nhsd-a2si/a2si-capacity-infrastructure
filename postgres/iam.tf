data "aws_iam_instance_profile" "a2si-eb" {
  name = "${var.nhs_owner_shortcode}-a2si-elasticbeanstalk-ec2-role"
}
