resource "null_resource" "this" {
  triggers = {
    requirements = filesha1("${path.module}/${local.requirements_path}")
  }

  provisioner "local-exec" {
    command = <<EOT
      cd ${path.module}/${local.layer_path}
      rm -rf python
      mkdir python
      pip3 install -r ../${local.requirements_name} -t python/
      zip -r ${local.layer_zip_name} python/
    EOT
  }
}

resource "aws_s3_bucket" "this" {
  bucket = "assets-${local.aws_account_id}"
}

resource "aws_s3_object" "this" {
  depends_on = [null_resource.this]

  bucket = aws_s3_bucket.this.id
  key    = "lambda_layer/${local.layer_name}/${local.layer_zip_name}"
  source = "${path.module}/${local.layer_path}/${local.layer_zip_name}"
}

resource "aws_lambda_layer_version" "this" {
  depends_on = [aws_s3_object.this]

  s3_bucket           = aws_s3_bucket.this.id
  s3_key              = aws_s3_object.this.key
  layer_name          = local.layer_name
  compatible_runtimes = ["${local.compatible_runtimes}"]
  skip_destroy        = true
}
