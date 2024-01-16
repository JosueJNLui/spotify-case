resource "aws_lambda_function" "this" {
  function_name = "${local.project_name}-${local.env}"
  handler       = "lambda_handler.lambda_handler"
  role          = aws_iam_role.this.arn
  runtime       = "python3.10"

  filename         = data.archive_file.spotify-artefact.output_path
  source_code_hash = data.archive_file.spotify-artefact.output_base64sha256

  timeout     = 5
  memory_size = 128


}
