resource "aws_iam_policy" "this" {
  name   = "${local.project_name}-${local.env}-policy"
  policy = local.iam_policy_document
}

resource "aws_iam_role" "this" {
  name               = "${local.project_name}-${local.env}-role"
  assume_role_policy = "${local.iam_policy_assume_role}"
}

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = aws_iam_policy.this.arn
  role       = aws_iam_role.this.name

  depends_on = [aws_iam_policy.this, aws_iam_role.this]
}
