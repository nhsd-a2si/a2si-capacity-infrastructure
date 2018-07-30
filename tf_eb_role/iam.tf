resource "aws_iam_role" "a2si-eb" {
  name        = "${var.nhs_owner_shortcode}-a2si-elasticbeanstalk-ec2-role"
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
