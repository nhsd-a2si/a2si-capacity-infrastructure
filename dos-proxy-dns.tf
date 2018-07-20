resource "aws_route53_record" "dos-proxy-lb" {
  zone_id = "${data.aws_route53_zone.capacity_hosted_zone.id}"
  type    = "CNAME"
  name    = "${var.dos_proxy_fq_domain_name}"
  records = ["${aws_elastic_beanstalk_environment.dos-proxy-env.cname}"]
  ttl     = 5
  health_check_id = "${aws_route53_health_check.dos-proxy-heathcheck.id}"
  set_identifier = "Primary"
  failover_routing_policy {
    type = "PRIMARY"
  }
}

resource "aws_route53_record" "dos-proxy-failover" {
  zone_id = "${data.aws_route53_zone.capacity_hosted_zone.id}"
  name    = "${var.dos_proxy_fq_domain_name}"
  records = ["${var.dos_service_domain}"]
  type    = "CNAME"
  ttl     = "5"

  set_identifier = "Secondary"

  failover_routing_policy {
    type = "SECONDARY"
  }

}

resource "aws_route53_health_check" "dos-proxy-heathcheck" {
  type = "HTTPS_STR_MATCH"
  port = "443"
  resource_path = "/healthcheck"
  fqdn = "${aws_elastic_beanstalk_environment.dos-proxy-env.cname}"
  request_interval = "10"
  failure_threshold = "1"
  search_string = "UP"
  tags {
    Name = "Dos Proxy Terraform"
  }
}

output "dos_proxy_lb_fqdn" {
  value = "${aws_route53_record.dos-proxy-lb.fqdn}"
}
