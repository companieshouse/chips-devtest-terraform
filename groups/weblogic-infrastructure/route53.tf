resource "aws_route53_record" "app" {
  for_each = {for env in var.environments: env.name => env}

  zone_id = data.aws_route53_zone.private_zone.zone_id
  name    = "${var.application_type}-${each.value.name}"
  type    = "A"

  alias {
    name                   = module.internal_alb.lb_dns_name
    zone_id                = module.internal_alb.lb_zone_id
    evaluate_target_health = true
  }
}