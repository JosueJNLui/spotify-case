module "iam" {
  source                 = "../modules/iam"
  project_name           = local.project_name
  env                    = local.env
  iam_policy_document    = data.aws_iam_policy_document.this.json
  iam_policy_assume_role = data.aws_iam_policy_document.lambda_assume_role.json
}
