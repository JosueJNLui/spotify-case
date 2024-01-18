locals {
  aws_account_id = data.aws_caller_identity.current.account_id
  env            = var.env
  aws_region     = var.aws_region
  aws_profile    = var.aws_profile
  project_name   = var.project_name

  function_name   = "${var.project_name}-${var.env}-handler"
  layer_pandassdk = "arn:aws:lambda:${var.aws_region}:336392948345:layer:AWSSDKPandas-Python310:8"

  requirements_path = "../../spotify-infra/${local.requirements_name}"
  layer_path        = "../../spotify-infra/files"
  requirements_name = "requirements.txt"
  layer_name        = "lambda_layer_${var.project_name}"
  layer_zip_name    = "layer.zip"

  # Locals required on the scheduler resource
  scheduler_name  = "recently-played-songs"
  group_name      = "default"
  cron_rule       = "rate(30 minutes)"
  target_arn      = module.lambda.lambda.arn
  target_role_arn = module.iam.role.arn
}
