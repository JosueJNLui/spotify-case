output "role" {
  value = {
    name = aws_iam_role.this.name
    arn  = aws_iam_role.this.arn
  }
}
