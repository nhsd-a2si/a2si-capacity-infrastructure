resource "aws_route53_record" "capacity-service-lb" {
  zone_id = "${data.aws_route53_zone.capacity_public_domain.id}"
  type    = "CNAME"
  name    = "${var.capacity_service_hostname}.${var.public_domain}"
  records = ["${aws_elastic_beanstalk_environment.capacity-service-env.cname}"]
  ttl     = 60
}

output "capacity_service_lb_fqdn" {
  value = "${aws_route53_record.capacity-service-lb.fqdn}"
}
