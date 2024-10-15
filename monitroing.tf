# module "monitoring" {
#   source     = "./monitoring"
#   depends_on = [aws_iam_openid_connect_provider.eks_cluster, time_sleep.wait_for_kubernetes, kubernetes_namespace.monitoring-stack]
# }
# resource "kubernetes_namespace" "monitoring-stack" {
#   metadata {
#     name = "monitoring-stack"
#   }
# }
# resource "time_sleep" "wait_for_kubernetes" {

#   depends_on = [
#     data.aws_eks_cluster.eks_cluster
#   ]

#   create_duration = "20s"
# }

# # resource "null_resource" "run_shell_command" {
# #   depends_on = [aws_eks_cluster.eks_cluster]
# #   provisioner "local-exec" {
# #     command = "aws eks update-kubeconfig --region us-east-1 --name eks-master-cluster"
# #   }
# # }