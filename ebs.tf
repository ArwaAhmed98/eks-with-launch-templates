# resource "aws_eks_addon" "csi_driver" {
#   cluster_name             = aws_eks_cluster.eks_cluster.name
#   addon_name               = "aws-ebs-csi-driver"
#   addon_version            = "v1.35.0-eksbuild.1"
#   service_account_role_arn = aws_iam_role.eks_ebs_csi_driver.arn
# }
# data "aws_iam_policy_document" "csi" {
#   statement {
#     actions = ["sts:AssumeRoleWithWebIdentity"]
#     effect  = "Allow"

#     condition {
#       test     = "StringEquals"
#       variable = "${replace(aws_iam_openid_connect_provider.eks_cluster.url, "https://", "")}:sub"
#       values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
#     }

#     principals {
#       identifiers = [aws_iam_openid_connect_provider.eks_cluster.arn]
#       type        = "Federated"
#     }
#   }
# }
# resource "aws_iam_role" "eks_ebs_csi_driver" {
#   assume_role_policy = data.aws_iam_policy_document.csi.json
#   name               = "eks-ebs-csi-driver"
# }

# resource "aws_iam_role_policy_attachment" "amazon_ebs_csi_driver" {
#   role       = aws_iam_role.eks_ebs_csi_driver.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
# }