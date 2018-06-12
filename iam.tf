resource "aws_iam_role" "ebs-role" {
  name        = "a2si-elasticbeanstalk-ec2-role"
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

resource "aws_iam_role_policy_attachment" "AWSElasticBeanstalkWebTier-attach" {
  role       = "${aws_iam_role.ebs-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "AWSElasticBeanstalkService-attach" {
  role       = "${aws_iam_role.ebs-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}

resource "aws_iam_instance_profile" "eb-instance-profile" {
  name = "a2si-elasticbeanstalk-ec2-role-instance-profile"
  role = "${aws_iam_role.ebs-role.name}"
}
