resource "aws_route53_record" "dos-proxy-lb" {
  zone_id = "${data.aws_route53_zone.capacity_hosted_zone.id}"
  type    = "CNAME"
  name    = "${var.dos_proxy_fq_domain_name}"
  records = ["${aws_elastic_beanstalk_environment.dos-proxy-env.cname}"]
  ttl     = 5
}

// Needs more work
resource "aws_route53_health_check" "dos-proxy-heathcheck" {
  type = "HTTPS_STR_MATCH"
  port = "443"
  resource_path = "/heathcheck"
  fqdn = "${aws_route53_record.dos-proxy-lb.fqdn}"
  request_interval = "10"
  failure_threshold = "1"
  search_string = "UP"
  tags {
    Name = "${aws_route53_record.dos-proxy-lb.fqdn}"
  }
}

output "dos_proxy_lb_fqdn" {
  value = "${aws_route53_record.dos-proxy-lb.fqdn}"
}
