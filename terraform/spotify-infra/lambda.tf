module "lambda" {
  source        = "../modules/lambda"
  function_name = local.function_name
  layers = [
    local.layer_pandassdk,
    module.lambda_layer.lambda_layer.arn
  ]
  role             = module.iam.role.arn
  filename         = data.archive_file.this.output_path
  source_code_hash = data.archive_file.this.output_base64sha256
  variables = {
    "ACCOUNT_ID" = local.aws_account_id,
    "EXEC_ENV"   = local.env
  }

  depends_on = [module.lambda_layer.aws_s3_object]
}
