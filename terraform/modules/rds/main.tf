# resource "aws_db_subnet_group" "this" {
#   name       = "dbsubnet"
#   subnet_ids = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_b.id]
# }

resource "random_password" "master_password" {
  length           = 20
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "password" {
  name                    = "dev-rds-credentials"
  recovery_window_in_days = 0
}

# resource "aws_security_group" "rds_sg" {
#   name   = "rds-sg"
#   vpc_id = aws_vpc.this.id

#   ingress {
#     from_port   = 5432
#     to_port     = 5432
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] # ["170.80.153.29/32"]
#   }
# }

resource "aws_db_instance" "this" {
  identifier             = local.identifier
  publicly_accessible    = false
  allocated_storage      = local.allocated_storage
  engine                 = local.engine
  engine_version         = local.engine_version
  instance_class         = local.instance_class
  db_name                = local.db_name
  username               = local.username
  password               = random_password.master_password.result
  skip_final_snapshot    = local.skip_final_snapshot
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.id
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  depends_on = [random_password.master_password, aws_db_subnet_group.db_subnet_group, aws_security_group.rds_sg]
}

resource "aws_secretsmanager_secret_version" "password" {
  secret_id     = aws_secretsmanager_secret.password.id
  secret_string = <<EOF
  {
    "username": "${local.username}",
    "password": "${random_password.master_password.result}",
    "engine": "${local.engine}",
    "host": "${aws_db_instance.this.address}",
    "port": "${aws_db_instance.this.port}",
    "dbname": "${local.db_name}"
  }
EOF

  depends_on = [aws_secretsmanager_secret.password, aws_db_instance.this, random_password.master_password]
}
