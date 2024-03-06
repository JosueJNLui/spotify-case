locals {
  identifier          = var.identifier
  allocated_storage   = var.allocated_storage
  engine              = var.engine
  engine_version      = var.engine_version
  instance_class      = var.instance_class
  db_name             = var.db_name
  username            = var.username
  skip_final_snapshot = var.skip_final_snapshot

  vpc_cidr_block            = var.vpc_cidr_block
  public_subnet_cidr_block  = var.public_subnet_cidr_block
}
