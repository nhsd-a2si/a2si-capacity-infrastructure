resource "aws_acm_certificate" "capacity-service-lb" {
  domain_name       = "${var.capacity_service_hostname}.${var.public_domain}"
  validation_method = "DNS"

  tags {
    Environment = "${var.environment}"
    Owner = "${var.nhs_owner}"
    Programme = "${var.nhs_programme_name}"
    Project = "${var.nhs_project_name}"
    Terraform = "true"
  }
}

resource "aws_route53_record" "capacity-service-lb-cert-validation" {
  name = "${aws_acm_certificate.capacity-service-lb.domain_validation_options.0.resource_record_name}"
  type = "${aws_acm_certificate.capacity-service-lb.domain_validation_options.0.resource_record_type}"
  zone_id = "${data.aws_route53_zone.capacity_public_domain.id}"
  records = ["${aws_acm_certificate.capacity-service-lb.domain_validation_options.0.resource_record_value}"]
  ttl = 60
}

resource "aws_acm_certificate_validation" "capacity-service-lb" {
  certificate_arn = "${aws_acm_certificate.capacity-service-lb.arn}"
  validation_record_fqdns = ["${aws_route53_record.capacity-service-lb-cert-validation.fqdn}"]
}
