# # Create AWS EKS Node Group - private
# resource "aws_eks_node_group" "eks_ng_private" {
#   cluster_name = aws_eks_cluster.eks_cluster.name

#   node_group_name = "eks-ng-private"
#   node_role_arn   = aws_iam_role.eks_nodegroup_role.arn
#   subnet_ids      = module.vpc.private_subnets
#   #version = var.cluster_version #(Optional: Defaults to EKS Cluster Kubernetes version)    


#   launch_template {
#    name = aws_launch_template.private_ng_launch_template.name
#    version = aws_launch_template.private_ng_launch_template.latest_version
#   }


#   scaling_config {
#     desired_size = 1
#     min_size     = 1
#     max_size     = 2
#   }

#   update_config {
#     max_unavailable = 1
#   }

#   depends_on = [
#     aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
#     aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
#     aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly,
#   ]

#   tags = {
#     Name = "private-Node-Group"
#   }
#   labels = {
#     key   = "type"
#     value = "private-ng"
#   }
#   taint {
#     key    = "type"
#     value  = "private-ng"
#     effect = "PREFER_NO_SCHEDULE"
#   }
# }


# data "aws_ami" "eks_worker_ami" {
#   most_recent = true
#   owners      = ["602401143452"] # Amazon EKS optimized AMIs

#   filter {
#     name   = "name"
#     values = ["amazon-eks-node-*"]
#   }
# }

# resource "aws_launch_template" "private_ng_launch_template" {
#   name = "private_ng_launch_template"

#   vpc_security_group_ids = [aws_security_group.allow_access_from_public_nodes.id] # allow ssh from basition

#   block_device_mappings {
#     device_name = "/dev/xvda"

#     ebs {
#       volume_size = 20
#       volume_type = "gp2"
#     }
#   }
  
#   lifecycle {
#     create_before_destroy = false
#   }
#   key_name  = "eks-terraform-key"
#   # image_id = "ami-0ef4d5e10609a6dbe" # ubuntu 22 lts, us-east-1
#   image_id      = data.aws_ami.eks_worker_ami.id
#   instance_type = "t3.medium"
#   # user_data = base64encode(<<-EOF

#   # EOF
#   # )

#   tag_specifications {
#     resource_type = "instance"

#     tags = {
#       Name = "private_nodes"
#     }
#   }
# }

