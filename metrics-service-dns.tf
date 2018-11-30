resource "aws_route53_record" "metrics-service-lb" {
  zone_id = "${data.aws_route53_zone.capacity_hosted_zone.id}"
  type    = "CNAME"
  name    = "${var.metrics_service_fq_domain_name}"
  records = ["${aws_elastic_beanstalk_environment.metrics-service-env.cname}"]
  ttl     = 60
}

output "metrics_service_lb_fqdn" {
  value = "${aws_route53_record.metrics-service-lb.fqdn}"
}
