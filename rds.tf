resource "aws_db_instance" "postgres" {
  allocated_storage    = 20
  db_name              = "mydw"
  engine               = "postgres"
  engine_version       = "18.1"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "admin123!"
  skip_final_snapshot  = true
  publicly_accessible  = true
  multi_az             = false
}