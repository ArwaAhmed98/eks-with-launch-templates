resource "aws_security_group" "example" {
  name_prefix = "example"
  vpc_id      = module.vpc.vpc_id 
  ingress {
    from_port   = 0
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.102.0/23"]  # Summation of cidrs of private subnets
    # ["10.0.0.0/16"] # should be the private subnets id
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# create the subnet group for the rds instance
resource "aws_db_subnet_group" "database_subnet_group" {
  name         = "db-rds-subnet-gruop"
  subnet_ids   = module.vpc.private_subnets
  description  = "private subnets"

  tags   = {
    Name = "db private subnet group "
  }
}


# create the rds instance
resource "aws_db_instance" "db_instance" {
  engine                  = "mysql"
  engine_version          = "8.0.34"
  multi_az                = false
  identifier              = "myrds"
  username                = "arwa"
  password                = "arwa1234"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_subnet_group_name    = aws_db_subnet_group.database_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.example.id , aws_security_group.allow_ssh_from_public_nodes.id ]
  availability_zone       = module.vpc.azs[1]
  db_name                 = "rds"
  skip_final_snapshot     = true
}

variable "rds-db-username" {
  type = string
  default = "arwa"
}
variable "rds-db-password" {
  type = string
  default ="arwa1234"
}

# OUTPUTS #
output "rds_endpoint" {
  value = aws_db_instance.db_instance.endpoint
  description = "RDS Endpoint for MySQL"
}

output "db_name" {
  value = aws_db_instance.db_instance.db_name
  description = "Database Name"
}

output "db_username" {
  value = aws_db_instance.db_instance.username
  description = "Database Username"
}

output "db_password" {
  value = aws_db_instance.db_instance.password
  senstive = true
  description = "Database Password"
}