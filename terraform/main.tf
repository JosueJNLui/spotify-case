resource "aws_s3_bucket" "spotify-bucket" {
  bucket = "spotify-case-${local.aws_region}-${local.aws_account_id}-${local.env}"

  tags = {
    Name = "spotify-bucket"
  }
}