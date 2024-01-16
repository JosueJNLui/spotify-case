locals {
  aws_account_id = data.aws_caller_identity.current.account_id
  env            = var.env
  aws_region     = var.aws_region
  aws_profile    = var.aws_profile
  project_name   = var.project_name

  layer_path        = "files"
  layer_zip_name    = "layer.zip"
  layer_name        = "lambda_layer_${local.env}"
  requirements_name = "requirements.txt"
  requirements_path = "${path.module}/${local.requirements_name}"
}
