locals {
  env                          = var.env
  scheduler_name               = var.scheduler_name
  group_name                   = var.group_name
  cron_rule                    = var.cron_rule
  schedule_expression_timezone = var.schedule_expression_timezone
  target_arn                   = var.target_arn
  target_role_arn              = var.target_role_arn
}
