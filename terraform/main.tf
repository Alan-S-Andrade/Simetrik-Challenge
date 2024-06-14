provider "aws" {
  region = "us-east-1"
}

module "networking" {
  source                   = "./modules/networking"
  vpc_cidr_block           = "10.0.0.0/16"
  public_subnet_count      = 2
  private_subnet_count     = 2
  public_subnets_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets_cidr_blocks = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones       = ["us-east-1a", "us-east-1b"]
}

module "eks" {
  source                  = "./modules/eks"
  cluster_name            = "grpc-cluster"
  cluster_role_arn        = aws_iam_role.eks_cluster.arn
  node_group_name         = "grpc-node-group"
  node_role_arn           = aws_iam_role.eks_node.arn
  subnet_ids              = module.networking.private_subnets
  vpc_id                  = module.networking.vpc_id
  security_group_id       = module.networking.eks_security_group_id
  server_host             = "server.grpc.local"
}

resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
  ]
}

resource "aws_iam_role" "eks_node" {
  name = "eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
  ]
}

terraform {
  backend "s3" {
    bucket         = "simetrik-terraform-state-bucket"
    key            = "path/to/simetrik/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}

