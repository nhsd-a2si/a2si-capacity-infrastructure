resource "aws_route53_record" "dos-proxy-lb" {
  zone_id = "${data.aws_route53_zone.capacity_hosted_zone.id}"
  type    = "CNAME"
  name    = "${var.dos_proxy_fq_domain_name}"
  records = ["${aws_elastic_beanstalk_environment.dos-proxy-env.cname}"]
  ttl     = 5
}

output "dos_proxy_lb_fqdn" {
  value = "${aws_route53_record.dos-proxy-lb.fqdn}"
}
