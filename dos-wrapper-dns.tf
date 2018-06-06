resource "aws_route53_record" "dos-wrapper-lb" {
  zone_id = "${data.aws_route53_zone.capacity_public_domain.id}"
  type    = "CNAME"
  name    = "${var.dos_wrapper_hostname}.${var.public_domain}"
  records = ["${aws_elastic_beanstalk_environment.dos-wrapper-env.cname}"]
  ttl     = 60
}

output "dos_wrapper_lb_fqdn" {
  value = "${aws_route53_record.dos-wrapper-lb.fqdn}"
}
