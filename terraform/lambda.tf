resource "aws_lambda_function" "this" {
  depends_on = [aws_s3_object.lambda_layer_zip]

  function_name = "${local.project_name}-${local.env}"
  handler       = "lambda_handler.lambda_handler"

  layers = [
    aws_lambda_layer_version.lambda_layer.arn,
    "arn:aws:lambda:us-east-2:336392948345:layer:AWSSDKPandas-Python310:8"
  ]

  role    = aws_iam_role.this.arn
  runtime = "python3.10"

  environment {
    variables = {
      "ACCOUNT_ID" = local.aws_account_id,
      "EXEC_ENV"   = local.env
    }
  }

  filename         = data.archive_file.spotify-artefact.output_path
  source_code_hash = data.archive_file.spotify-artefact.output_base64sha256

  timeout     = 10
  memory_size = 128
}
