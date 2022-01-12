# reference https://www.youtube.com/watch?v=WFFxqJOLh5I
# https://github.com/terraform-aws-modules/terraform-aws-rds
resource "aws_db_instance" "rds_mysql" {
  identifier = "rds-mysql-db"
  storage_type = "gp2"
  allocated_storage = 20
  engine = "mysql"
  engine_version = "8.0.23"
  instance_class = "db.t2.micro"
  port = "3306"
  #db_subnet_group_name = "default_terraform" #Optional, had to previously create this DB group in AWS 
  name = "myRDS_db"
  username = var.username
  password = var.password
  parameter_group_name = "rdsmysqlgroup" #had to create parameter group in aws previous to running this
  #availability_zone = "us-east-1a" #optional
  skip_final_snapshot = true
#values above are for aws free tier, vpc value comes from test env

tags = {
   Name = "Test mySQL RDS instance"
  }

}
