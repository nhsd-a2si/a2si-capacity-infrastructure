data "aws_route53_zone" "capacity_public_domain" {
  name         = "${var.public_domain}."
  private_zone = false
}
