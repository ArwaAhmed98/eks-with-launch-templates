resource "aws_security_group" "allow_access_from_bastion" {
  name        = "allow-access-from-bastion"
  description = "Security group allowing access from the bastion host"
  vpc_id      = module.vpc.vpc_id # Replace with your VPC ID or pass as a variable



  ingress {
    # from_port   = 0
    # to_port     = 0
    # protocol    = "-1" # All protocols
    # cidr_blocks = ["0.0.0.0/0"]
    # description = "Allow SSH access from Bastion Host"
    from_port       = 22 # SSH port
    to_port         = 22
    protocol        = "tcp"
    security_groups = [module.bastion_sg.security_group_id] # Reference bastion security group
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp" # All protocols
    cidr_blocks = ["10.0.0.0/16"]
    description = "Allow inbound traffic to control plane"
  }

  # Example egress rule (optional, modify as needed)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-access-from-bastion"
  }
}

###### SG of Private EKS Node Group ###########
resource "aws_security_group" "allow_ssh_from_public_nodes" {
  name        = "allow_ssh_from_public_nodes"
  description = "Security group allowing access from the bastion host"
  vpc_id      = module.vpc.vpc_id # Replace with your VPC ID or pass as a variable

  ingress {
    # from_port   = 0
    # to_port     = 0
    # protocol    = "-1" # All protocols
    # cidr_blocks = ["0.0.0.0/0"]
    # description = "Allow SSH access from Bastion Host"
    from_port       = 22 # SSH port
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.allow_access_from_bastion.id] # Reference bastion security group
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp" # All protocols
    cidr_blocks = ["10.0.0.0/16"]
    description = "Allow inbound traffic to control plane"
  }

  # Example egress rule (optional, modify as needed)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-access-from-public-nodes"
  }
}