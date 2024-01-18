output "lambda_layer" {
  value = {
    arn = aws_lambda_layer_version.this.arn
  }
}
