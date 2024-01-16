data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

      principals {
        type        = "Service"
        identifiers = ["lambda.amazonaws.com"]
      }
  }
}

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "AllowCreatingLogGroups"
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:*"]
    actions   = ["logs:CreateLogGroup"]
  }

  statement {
    sid       = "AlloWritingLogs"
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:log-group:/aws/lambda/*:*"]

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
  }

  statement {
    sid = "AllowWritingS3Bucket"
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${local.project_name}-${local.aws_region}-${local.aws_account_id}-${local.env}/",
      "arn:aws:s3:::${local.project_name}-${local.aws_region}-${local.aws_account_id}-${local.env}/*"
    ]

    actions = [
      "s3:PutObject"
    ]
  }
}

data "archive_file" "spotify-artefact" {
  output_path = "files/spotify-artefact.zip"
  type        = "zip"
  source_file = "./lambda_handler.py"
}
