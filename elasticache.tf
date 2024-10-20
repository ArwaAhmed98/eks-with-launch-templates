module "elasticache" {
  source = "terraform-aws-modules/elasticache/aws"

  cluster_id               = "example-redis"
  create_cluster           = true
  create_replication_group = false

  engine_version = "7.1"
  node_type      = "cache.t3.medium"

  maintenance_window         = "sun:05:00-sun:09:00"
  apply_immediately          = true
  transit_encryption_enabled = true
#   auth_token                 = var.auth_token
  # Security group
  vpc_id = module.vpc.vpc_id
  security_group_rules = {
    ingress_vpc = {
      # Default type is `ingress`
      # Default port is based on the default engine port
      description = "VPC traffic"
      cidr_ipv4   = "10.0.0.0/16" # cidrs of private subnets
      # cidr_ipv4 = "0.0.0.0/0"
    }
  }

  # Subnet Group
  subnet_ids = module.vpc.private_subnets

  # Parameter Group
  create_parameter_group = true
  parameter_group_family = "redis7"
  parameters = [
    {
      name  = "latency-tracking"
      value = "yes"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
# variable "auth_token" {
#   type    = string
#   default = "arwa1234"
# }
# # Extract the address from the first cache node
output "redis_address" {
  value       = module.elasticache.cluster_cache_nodes[0].address
  description = "The address of the Redis cache node"
} # Extract the port from the first cache node
output "redis_port" {
  value       = module.elasticache.cluster_cache_nodes[0].port
  description = "The port of the Redis cache node"
}
# output "redis_password" {
#   value = var.auth_token
#   sensitive = true
# }