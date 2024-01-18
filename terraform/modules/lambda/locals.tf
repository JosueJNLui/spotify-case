locals {
  function_name    = var.function_name
  handler          = var.handler
  layers           = var.layers
  role             = var.role
  runtime          = var.runtime
  timeout          = var.timeout
  memory_size      = var.memory_size
  filename         = var.filename
  source_code_hash = var.source_code_hash
  variables        = var.variables
}
