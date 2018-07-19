resource "aws_acm_certificate" "dos-proxy-lb" {
  domain_name       = "${var.dos_proxy_fq_domain_name}"
  validation_method = "DNS"

  tags {
    Environment = "${var.environment}"
    Owner = "${var.nhs_owner}"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Terraform = "true"
  }
}

resource "aws_route53_record" "dos-proxy-lb-cert-validation" {
  name = "${aws_acm_certificate.dos-proxy-lb.domain_validation_options.0.resource_record_name}"
  type = "${aws_acm_certificate.dos-proxy-lb.domain_validation_options.0.resource_record_type}"
  zone_id = "${data.aws_route53_zone.capacity_hosted_zone.id}"
  records = ["${aws_acm_certificate.dos-proxy-lb.domain_validation_options.0.resource_record_value}"]
  ttl = 5
}

resource "aws_acm_certificate_validation" "dos-proxy-lb" {
  certificate_arn = "${aws_acm_certificate.dos-proxy-lb.arn}"
  validation_record_fqdns = ["${aws_route53_record.dos-proxy-lb-cert-validation.fqdn}"]
}
