
# resource "helm_release" "ingress-nginx" {
#   name             = "ingress-nginx"
#   repository       = "https://kubernetes.github.io/ingress-nginx"
#   chart            = "ingress-nginx"
#   namespace        = "ingress"
#   version          = "4.0.13"
#   create_namespace = true
#   timeout          = 300

#   values = [
#     "${file("lb_values.yaml")}"
#   ]

#   set {
#     name  = "cluster.enabled"
#     value = "true"
#   }

#   set {
#     name  = "metrics.enabled"
#     value = "true"
#   }

#   depends_on = [aws_iam_openid_connect_provider.eks_cluster]

# }
