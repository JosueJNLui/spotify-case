module "lambda_layer" {
  source            = "../modules/lambda_layer"
  requirements_path = local.requirements_path
  layer_path        = local.layer_path
  layer_name        = local.layer_name
  requirements_name = local.requirements_name
  layer_zip_name    = local.layer_zip_name
  aws_account_id    = data.aws_caller_identity.current.account_id
}
