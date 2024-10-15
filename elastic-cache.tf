# resource "aws_elasticache_cluster" "example" {
#   cluster_id           = aws_eks_cluster.eks_cluster.id
#   engine               = "redis"
#   node_type            = "cache.m4.large"
#   num_cache_nodes      = 1
#   parameter_group_name = "default.redis3.2"
#   engine_version       = "3.2.10"
#   port                 = 6379
#   security_group_ids = [aws_security_group.private_nodes_sg.id ]#  should be sg of eks or private nodes of eks
#   subnet_group_name = aws_elasticache_subnet_group.bar.name
# }
# # assumption that the deployment/services that runs on the private nodes, will connect to the db

# resource "aws_elasticache_subnet_group" "bar" {
#   name       = "tf-test-cache-privatesubnet"
#   subnet_ids = module.vpc.private_subnets
# }


# resource "aws_db_instance" "myrds" {
#   allocated_storage    = 10
#   engine               = "mysql"
#   engine_version       = "5.7"
#   instance_class       = "db.t2.micro"
#   db_name                 = "mydb"
#   username = var.username
#   password = var.password
#   parameter_group_name = "default.mysql5.7"
#   skip_final_snapshot  = true
#   db_subnet_group_name =  aws_db_subnet_group.mydb.name 
#   vpc_security_group_ids = [aws_security_group.private_nodes_sg.id]
# }

# resource "aws_db_subnet_group" "mydb" {
#   name       = "dbmysql"
#  subnet_ids =  module.vpc.private_subnets

#   tags = {
#     Name = "Mysql with rds DB subnet group"
#   }
# }   