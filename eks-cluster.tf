resource "aws_eks_cluster" "eks_cluster" {
  name     = "eks-master-cluster"
  role_arn = aws_iam_role.eks_master_role.arn
  vpc_config {
    # subnet_ids              = concat(module.vpc.public_subnets,module.vpc.private_subnets)
    subnet_ids = module.vpc.public_subnets
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
    # public_access_cidrs = module.bastion_sg.security_group_id  # CLUSTER should only be accessed from basition host
    public_access_cidrs = var.cluster_endpoint_public_access_cidrs
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.cluster_service_ipv4_cidr
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy,
  aws_iam_role_policy_attachment.eks-AmazonEKSVPCResourceController]

}
data "tls_certificate" "eks_cluster" {
  url = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks_cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_cluster.certificates[0].sha1_fingerprint]
  url             = data.tls_certificate.eks_cluster.url
}
