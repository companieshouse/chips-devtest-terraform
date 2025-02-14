module "internal_alb_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.3"

  name        = "sgr-${var.application}-internal-alb-001"
  description = "Security group for the ${var.application} servers"
  vpc_id      = data.aws_vpc.vpc.id

  ingress_prefix_list_ids  = [data.aws_ec2_managed_prefix_list.administration.id]
  ingress_rules       = ["http-80-tcp","https-443-tcp"]
  egress_rules        = ["all-all"]
}

resource "aws_security_group_rule" "http_to_chips" {
  description       = "HTTP from application, chs and test subnets"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  type              = "ingress"
  cidr_blocks       = concat(local.chs_cidrs, local.application_subnet_cidrs, local.test_cidrs)
  security_group_id = module.internal_alb_security_group.security_group_id
}

resource "aws_security_group_rule" "https_to_chips" {
  description       = "HTTPS from application, chs and test subnets"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  type              = "ingress"
  cidr_blocks       = concat(local.chs_cidrs, local.application_subnet_cidrs, local.test_cidrs)
  security_group_id = module.internal_alb_security_group.security_group_id
}

module "internal_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.5"

  name                       = "alb-${var.application}-int-01"
  vpc_id                     = data.aws_vpc.vpc.id
  internal                   = true
  load_balancer_type         = "application"
  enable_deletion_protection = false
  idle_timeout               = 180

  security_groups = [module.internal_alb_security_group.security_group_id]
  subnets         = data.aws_subnet_ids.application.ids
  
  access_logs = {
    bucket = local.elb_access_logs_bucket_name
    prefix = local.elb_access_logs_prefix
    enabled = true
  }

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"

      action_type  = "fixed-response"
      fixed_response = {
        status_code  = "503"
        content_type = "text/plain"
      }
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = data.aws_acm_certificate.acm_cert.arn
      
      action_type  = "fixed-response"
      fixed_response = {
        status_code  = "503"
        content_type = "text/plain"
      }
    }
  ]

  http_tcp_listener_rules = [ 
    for index, env in var.environments : {
      http_tcp_listener_index = 0
      priority                = env.number

      actions = [
        {
          type               = "forward"
          target_group_index = index
          weight             = 100
        }
      ]
      conditions = [{ host_headers = [format("%s-%s.*", var.application_type, env.name)] }]
    }
  ]

  https_listener_rules = [ 
    for index, env in var.environments : {
      https_listener_index    = 0
      priority                = env.number

      actions = [
        {
          type               = "forward"
          target_group_index = index
          weight             = 100
        }
      ]
      conditions = [{ host_headers = [format("%s-%s.*", var.application_type, env.name)] }]
    }
  ]

  target_groups = [
    for env in var.environments : {
      name                 = format("tg-%s-%s", var.application, env.name)
      backend_protocol     = "HTTP"
      backend_port         = "2${env.number}00"
      target_type          = "instance"
      deregistration_delay = 60
      health_check = {
        enabled             = true
        interval            = 30
        path                = var.application_health_check_path
        port                = "2${env.number}00"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }

      tags = {
        InstanceTargetGroupTag = var.application
      }
    }
  ]
}
