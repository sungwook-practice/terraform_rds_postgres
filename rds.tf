resource "aws_rds_cluster" "postgresql" {
  cluster_identifier     = "terraform-demo"
  engine                 = "aurora-postgresql"
  engine_version         = var.rds_postgres_version
  db_subnet_group_name   = aws_db_subnet_group.db-subnet-group.name
  availability_zones     = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]
  vpc_security_group_ids = [aws_security_group.postgres.id]
  database_name          = "mydb"
  master_username        = "root"
  master_password        = var.rds_postgres_password
  skip_final_snapshot    = true # RDS 삭제 시, 스냅샷 생성 X
}

resource "aws_rds_cluster_instance" "aurora-mysql-db-instance" {
  identifier          = "terraform-test"
  cluster_identifier  = aws_rds_cluster.postgresql.id
  instance_class      = "db.t3.medium"
  engine              = "aurora-postgresql"
  engine_version      = var.rds_postgres_version
  publicly_accessible = true
}

resource "aws_security_group" "postgres" {
  vpc_id      = aws_vpc.main.id
  name        = "terraform-rds-test"
  description = "Allow all inbound for Postgres"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "terraform-rds-test"
  }
}

resource "aws_db_subnet_group" "db-subnet-group" {
  name       = "terraform-test"
  subnet_ids = [for public in aws_subnet.public : public.id]
}
