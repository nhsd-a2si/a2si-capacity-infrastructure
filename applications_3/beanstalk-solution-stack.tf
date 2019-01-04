data "aws_elastic_beanstalk_solution_stack" "single_docker" {
  most_recent   = true

  name_regex    = "^64bit Amazon Linux (.*) running Docker (.*)$"
}
