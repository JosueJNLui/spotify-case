resource "aws_scheduler_schedule" "this" {
  name                         = local.scheduler_name
  group_name                   = local.group_name
  schedule_expression          = local.cron_rule
  schedule_expression_timezone = local.schedule_expression_timezone
  state                        = local.env == "prod" ? "ENABLED" : "DISABLED"

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = local.target_arn
    role_arn = local.target_role_arn
  }
}
