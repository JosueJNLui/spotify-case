resource "aws_lambda_function" "this" {
  function_name    = local.function_name
  handler          = local.handler
  layers           = local.layers
  role             = local.role
  runtime          = local.runtime
  timeout          = local.timeout
  memory_size      = local.memory_size
  filename         = local.filename
  source_code_hash = local.source_code_hash

  environment {
    variables = local.variables
  }

}
