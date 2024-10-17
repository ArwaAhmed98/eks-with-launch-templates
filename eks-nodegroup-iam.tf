
resource "aws_iam_role" "public_eks_nodegroup_role" { # role of the ec2 of eks
  name = "public-eks-nodegroup-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}


#  policy of the worker nodes 
resource "aws_iam_role_policy_attachment" "eks-AmazonEKSWorkerNodePolicyy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.public_eks_nodegroup_role.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKS_CNI_Policyy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.public_eks_nodegroup_role.name
}
# Attaching Policy to IAM role
resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCoree" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.public_eks_nodegroup_role.name
}
# Attaching Policy to IAM role
resource "aws_iam_role_policy_attachment" "s33" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.public_eks_nodegroup_role.name
}
resource "aws_iam_role_policy_attachment" "eks-AmazonEC2ContainerRegistryReadOnlyy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.public_eks_nodegroup_role.name
}

# Creating IAM Policy for auto-scaler
resource "aws_iam_policy" "autoscalerr" {
  name = "ed-eks-autoscalerr-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeTags",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "ec2:DescribeLaunchTemplateVersions"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })
}
# Attaching Policy to IAM role
resource "aws_iam_role_policy_attachment" "autoscalerr" {
  policy_arn = aws_iam_policy.autoscalerr.arn
  role       = aws_iam_role.public_eks_nodegroup_role.name
}

resource "aws_iam_instance_profile" "public_eks_nodegroup_role" {
  depends_on = [aws_iam_role.public_eks_nodegroup_role]
  name       = "public-EKS-worker-nodes-profile"
  role       = aws_iam_role.public_eks_nodegroup_role.name
}