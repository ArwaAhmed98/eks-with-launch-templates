terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.10.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.3.0"
    }
    # kubectl = {
    #   source  = "gavinbunney/kubectl"
    #   version = "~> 1.14.0"
    # }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.9.0"
    }
  }
}

#terrafrom remote state block with s3

# backend "s3" {
#   bucket = "terraform-state-bucket81"
#   key = "terraform.tfstate"
#   dynamodb_table = "state-locking"
#   region = "us-west-1"
# }

# provider block to configure aws 

provider "aws" {
  region = "us-east-1"
}

data "aws_eks_cluster" "eks_cluster" {
  name = aws_eks_cluster.eks_cluster.name
  depends_on = [
    aws_eks_cluster.eks_cluster
  ]
}

data "aws_eks_cluster_auth" "auth" {
  name = aws_eks_cluster.eks_cluster.name
  depends_on = [
    aws_eks_cluster.eks_cluster
  ]
}

provider "helm" {
  kubernetes {
    # config_path = "~/.kube/config" # Optional, based on your setup
    host                   = data.aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.auth.token
  }
}

provider "kubernetes" {
      # config_path = "~/.kube/config" # Optional, based on your setup

  host                   = data.aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.auth.token
  
}



