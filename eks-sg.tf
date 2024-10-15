
resource "aws_security_group" "allow_access_from_bastion" {
  name        = "allow-access-from-bastion"
  description = "Security group allowing access from the bastion host"
  vpc_id      = module.vpc.vpc_id  # Replace with your VPC ID or pass as a variable

  ingress {
       from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All protocols
    cidr_blocks = ["0.0.0.0/0"]
    # description      = "Allow SSH access from Bastion Host"
    # from_port        = 22  # SSH port
    # to_port          = 22
    # protocol         = "tcp"
    # security_groups  = [module.bastion_sg.security_group_id]  # Reference bastion security group
  }

  # Example egress rule (optional, modify as needed)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-access-from-bastion"
  }
}





