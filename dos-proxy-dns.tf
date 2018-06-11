resource "aws_route53_record" "dos-proxy-lb" {
  zone_id = "${data.aws_route53_zone.capacity_public_domain.id}"
  type    = "CNAME"
  name    = "${var.dos_proxy_hostname}.${var.public_domain}"
  records = ["${aws_elastic_beanstalk_environment.dos-proxy-env.cname}"]
  ttl     = 60
}

output "dos_proxy_lb_fqdn" {
  value = "${aws_route53_record.dos-proxy-lb.fqdn}"
}
