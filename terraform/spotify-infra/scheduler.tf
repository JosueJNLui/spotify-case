module "scheduler" {
  source          = "../modules/scheduler"
  scheduler_name  = local.scheduler_name
  group_name      = local.group_name
  cron_rule       = local.cron_rule
  env             = local.env
  target_arn      = local.target_arn
  target_role_arn = local.target_role_arn
}
