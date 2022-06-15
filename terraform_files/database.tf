#Create my DB Subnet GROUPS

resource "aws_db_subnet_group" "dbgrp" {
  name       = "mydbgrp"
  subnet_ids = [aws_subnet.my_db-subnet[0].id, aws_subnet.my_db-subnet[1].id]
  #count      = 2
}

#Create my DB Instane

resource "aws_db_instance" "DB" {
  db_name                     = "mydb"
  engine                      = "mysql"
  engine_version              = "5.7"
  instance_class              = "db.t2.micro"
  storage_type                = "gp2"
  allocated_storage           = 20
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = false
  multi_az                    = false
  skip_final_snapshot         = true
  publicly_accessible         = false
  port                        = var.ports[3]
  maintenance_window          = "Fri:11:00-Fri:12:00"
  backup_retention_period     = 7
  backup_window               = "09:00-10:50"
  username                    = "admin"
  db_subnet_group_name     = aws_db_subnet_group.dbgrp.id
  password                 = "pas+D48+"
  vpc_security_group_ids   = [aws_security_group.DB_SG.id]
  delete_automated_backups = true
  apply_immediately        = true
  availability_zone        = var.zones[count.index]
  count                    = 2

}



