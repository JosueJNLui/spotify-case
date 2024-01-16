resource "null_resource" "lambda_layer" {
  triggers = {
    requirements = filesha1(local.requirements_path)
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

resource "aws_lambda_layer_version" "lambda_layer" {
  depends_on = [aws_s3_object.lambda_layer_zip]

  s3_bucket           = aws_s3_bucket.lambda_layer.id
  s3_key              = aws_s3_object.lambda_layer_zip.key
  layer_name          = local.layer_name
  compatible_runtimes = ["python3.10"]
  skip_destroy        = true
}
