module "rds" {
  source              = "../modules/rds"
  identifier          = "${local.project_name}-db-instance"
  db_name             = local.db_name
  allocated_storage   = 10
  username            = "useradmin"
  skip_final_snapshot = true
}
