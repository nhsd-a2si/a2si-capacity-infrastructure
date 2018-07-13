resource "aws_route53_record" "sftpserver" {
  zone_id = "${data.aws_route53_zone.capacity_hosted_zone.id}"
  name    = "${var.sftp_fq_domain_name}"
  type    = "A"
  ttl     = 60
  records = ["${aws_instance.sftpserver.public_ip}"]
}

output "sftp_fqdn" {
  value = "${aws_route53_record.sftpserver.fqdn}"
}
