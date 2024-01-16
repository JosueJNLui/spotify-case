resource "aws_s3_bucket" "spotify-bucket" {
  bucket = "${local.project_name}-${local.aws_region}-${local.aws_account_id}-${local.env}"

  tags = {
    Name = "spotify-bucket"
  }
}