locals {
    aws_account_id        = data.aws_caller_identity.current.account_id
    env                   = var.env
    aws_region            = var.aws_region
    aws_profile           = var.aws_profile
    project_name          = var.project_name
}