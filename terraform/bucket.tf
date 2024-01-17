resource "aws_s3_bucket" "spotify-bucket" {
  bucket = "${local.project_name}-${local.aws_region}-${local.aws_account_id}-${local.env}"

  tags = {
    Name = "spotify-bucket"
  }
}

resource "aws_s3_bucket" "lambda_layer" {
  bucket = "assets-${local.aws_account_id}"
}

resource "aws_s3_object" "lambda_layer_zip" {
  depends_on = [null_resource.lambda_layer]

  bucket = aws_s3_bucket.lambda_layer.id
  key    = "lambda_layer/${local.layer_name}/${local.layer_zip_name}"
  source = "${local.layer_path}/${local.layer_zip_name}"
}

