resource "aws_iam_role_policy_attachment" "AWSElasticBeanstalkWebTier" {
  role       = "${var.elasticbeanstalk_ec2_role_name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "AWSElasticBeanstalkService" {
  role       = "${var.elasticbeanstalk_ec2_role_name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}

resource "aws_iam_instance_profile" "a2si-eb" {
  name = "${var.nhs_owner_shortcode}-a2si-elasticbeanstalk-ec2-role"
  role = "${var.elasticbeanstalk_ec2_role_name}"
}
