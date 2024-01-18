output "lambda" {
  value = {
    arn = aws_lambda_function.this.arn
  }
}
