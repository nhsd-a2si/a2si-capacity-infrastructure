resource "aws_iam_role" "a2si-eb" {
  name        = "${var.nhs_owner}-a2si-elasticbeanstalk-ec2-role"
  description = ""

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSElasticBeanstalkWebTier" {
  role       = "${aws_iam_role.a2si-eb.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "AWSElasticBeanstalkService" {
  role       = "${aws_iam_role.a2si-eb.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}

resource "aws_iam_instance_profile" "a2si-eb" {
  name = "${var.nhs_owner}-a2si-elasticbeanstalk-ec2-role"
  role = "${aws_iam_role.a2si-eb.name}"
}
