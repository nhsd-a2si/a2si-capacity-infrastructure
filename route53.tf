data "aws_route53_zone" "capacity_hosted_zone" {
  name         = "${var.capacity_hosted_zone}."
  private_zone = false
}
