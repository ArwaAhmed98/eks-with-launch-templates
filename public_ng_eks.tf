# Create AWS EKS Node Group - Public
resource "aws_eks_node_group" "eks_ng_public" {
  cluster_name = aws_eks_cluster.eks_cluster.name

  node_group_name = "eks-ng-public"
  node_role_arn   = aws_iam_role.eks_nodegroup_role.arn
  subnet_ids      = module.vpc.public_subnets
  #version = var.cluster_version #(Optional: Defaults to EKS Cluster Kubernetes version)    
  ami_type = "CUSTOM"
  launch_template {
   name = aws_launch_template.public_ng_launch.name
   version = aws_launch_template.public_ng_launch.latest_version
  }

  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly,
  ]

  tags = {
    Name = "Public-Node-Group"
  }
  # labels = {
  #   key   = "type"
  #   value = "public-ng"
  # }
  # taint {
  #   key    = "type"
  #   value  = "public-ng"
  #   effect = "PREFER_NO_SCHEDULE"
  # }
}


data "aws_ami" "eks_worker_ami" {
  most_recent = true
  owners      = ["602401143452"] # Amazon EKS optimized AMIs
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "name"
    values = ["amazon-eks-node-1.30*"]
  }
}


# Extract the required details for user-data
locals {
  api_server_url = data.aws_eks_cluster.eks_cluster.endpoint
  b64_cluster_ca = data.aws_eks_cluster.eks_cluster.certificate_authority.0.data
}

resource "aws_launch_template" "public_ng_launch" {
  name = "public_ng_launch"

  vpc_security_group_ids = [aws_security_group.allow_access_from_bastion.id] # allow ssh from basition

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 20
      volume_type = "gp2"
    }
  }
  
  lifecycle {
    create_before_destroy = false
  }
  key_name  = "eks-terraform-key"
  image_id      = data.aws_ami.eks_worker_ami.id
  instance_type = "t3.medium"
  user_data = base64encode(<<-EOF
  #!/bin/bash
  /etc/eks/bootstrap.sh eks-master-cluster
    EOF
)
#   user_data = base64encode(<<-EOF
#   MIME-Version: 1.0
#   Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

#   --==MYBOUNDARY==
#   Content-Type: text/x-shellscript; charset="us-ascii"
#   #!/bin/bash
#   cd /home/ec2-user
#   touch x.txt
#   sudo /etc/eks/bootstrap.sh ${var.cluster_name} \
#     --apiserver-endpoint ${local.api_server_url} \
#     --b64-cluster-ca ${local.b64_cluster_ca} \
#     --node-labels "type=public-ng" \
#     --register-with-taints "type=public-ng:PreferNoSchedule"

#   --==MYBOUNDARY==--

#   EOF
# )

  metadata_options  {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "public_nodes"
    }
  }
}

