resource "aws_route53_record" "info-reader-lb" {
  zone_id = "${data.aws_route53_zone.capacity_public_domain.id}"
  type    = "CNAME"
  name    = "${var.info_reader_hostname}.${var.public_domain}"
  records = ["${aws_elastic_beanstalk_environment.info-reader-env.cname}"]
  ttl     = 60
}

output "info_reader_lb_fqdn" {
  value = "${aws_route53_record.info-reader-lb.fqdn}"
}
