locals {
  aws_account_id = data.aws_caller_identity.current.account_id
  env            = var.env
  aws_region     = var.aws_region
  aws_profile    = var.aws_profile
  project_name   = var.project_name

  # Locals required on the layer resource
  layer_path        = "files"
  layer_zip_name    = "layer.zip"
  layer_name        = "lambda_layer_${local.env}"
  requirements_name = "requirements.txt"
  requirements_path = "${path.module}/${local.requirements_name}"

  # Locals required on the scheduler resource

  scheduler_name  = "recently-played-songs"      # var.scheduler_name
  group_name      = "default"                    # var.group_name
  cron_rule       = "rate(30 minutes)"           # var.cron_rule
  target_arn      = aws_lambda_function.this.arn # var.target_arn
  target_role_arn = aws_iam_role.this.arn        # var.role_arn
}
