data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com", "scheduler.amazonaws.com"]
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
    sid    = "AllowWritingS3Bucket"
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${local.project_name}-${local.aws_region}-${local.aws_account_id}-${local.env}/",
      "arn:aws:s3:::${local.project_name}-${local.aws_region}-${local.aws_account_id}-${local.env}/*"
    ]

    actions = [
      "s3:PutObject"
    ]
  }

  statement {
    sid    = "AllowGetSSMParameters"
    effect = "Allow"
    resources = [
      "arn:aws:ssm:${local.aws_region}:${local.aws_account_id}:parameter/${local.env}-josu-client-id",
      "arn:aws:ssm:${local.aws_region}:${local.aws_account_id}:parameter/${local.env}-josu-client-secret",
      "arn:aws:ssm:${local.aws_region}:${local.aws_account_id}:parameter/spotify-refresh-token"
    ]

    actions = [
      "ssm:GetParameters"
    ]
  }

  statement {
    sid    = "AllowInvokeLambda"
    effect = "Allow"
    resources = [
      local.target_arn
    ]

    actions = [
      "lambda:InvokeFunction",
      "lambda:InvokeAsync",
      "lambda:InvokeFunctionUrl"
    ]
  }
}

data "archive_file" "this" {
  output_path = "files/spotify-artefact.zip"
  type        = "zip"
  source_file = "./lambda_handler.py"
}

