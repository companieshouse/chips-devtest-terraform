# ASG Scheduled Shutdown
resource "aws_autoscaling_schedule" "stop" {
  count = length(var.shutdown_schedule) > 0 ? 1 : 0

  scheduled_action_name  = "${var.aws_account}-${var.e2e_name}-scheduled-shutdown"
  min_size               = 0
  max_size               = 0
  desired_capacity       = 0
  recurrence             = var.shutdown_schedule
  time_zone              = "Europe/London"
  autoscaling_group_name = data.aws_autoscaling_groups.asg.names[0]
}

# ASG Scheduled Startup
resource "aws_autoscaling_schedule" "start" {
  count = length(var.startup_schedule) > 0 ? 1 : 0

  scheduled_action_name  = "${var.aws_account}-${var.e2e_name}-scheduled-startup"
  min_size               = var.asg_min_size
  max_size               = var.asg_max_size
  desired_capacity       = var.asg_desired_capacity
  recurrence             = var.startup_schedule
  time_zone              = "Europe/London"
  autoscaling_group_name = data.aws_autoscaling_groups.asg.names[0]
}
