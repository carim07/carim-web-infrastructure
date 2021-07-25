resource "aws_route53_zone" "zone" {
  name = "${var.domain}"
}

resource "aws_route53_record" "main" {
  zone_id = "${aws_route53_zone.zone.zone_id}"
  name = "${var.domain}"
  type = "A"

  alias {
    name = "${var.main_cdn_domain_name}"
    zone_id = "${var.main_cdn_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "redirect" {
  zone_id = "${aws_route53_zone.zone.zone_id}"
  name = "www.${var.domain}"
  type = "A"

  alias {
    name =   "${var.redirect_cdn_domain_name}"
    zone_id = "${var.redirect_cdn_zone_id}"
    evaluate_target_health = false
  }
}
