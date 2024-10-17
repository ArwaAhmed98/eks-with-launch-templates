module "ec2_bastion" {
  name                   = var.ec2_name
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "3.3.0"
  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.bastion_sg.security_group_id]
  # install openssh on aws linux 2
  user_data = <<-EOT
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y gcc make wget openssl-devel zlib-devel
    wget https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-9.6p1.tar.gz
    tar -zxvf openssh-9.6p1.tar.gz
    cd openssh-9.6p1
    ./configure
    make
    sudo make install
    sudo systemctl start sshd
    sudo systemctl enable sshd
    ssh -V
  EOT
  tags = {
    vpc = "bastion-host"
  }
}