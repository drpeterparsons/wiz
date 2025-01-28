provider "aws" {
  region = "eu-west-1"
}

# Create VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "k8s-mongo-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
}

# IAM Roles for EKS
module "eks-iam" {
  source  = "terraform-aws-modules/iam/aws//modules/eks"
  version = "~> 5.0"

  cluster_name = "k8s-cluster"
}

# Create EKS Cluster
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 19.0"

  cluster_name    = "k8s-cluster"
  cluster_version = "1.26"
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  node_groups = {
    k8s_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1

      instance_types = ["t3.medium"]
      key_name       = "pparsons-eu-west1"
    }
  }

  manage_aws_auth = true
  role_name       = module.eks-iam.role_name
}

# Security Group for MongoDB EC2 instance
resource "aws_security_group" "mongo_sg" {
  name        = "mongo-sg"
  description = "Allow MongoDB traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# MongoDB EC2 Instance
resource "aws_instance" "mongodb" {
  ami           = "ami-0720a3ca2735bf2fa" # Amazon Linux 2 AMI
  instance_type = "t3.medium"
  key_name      = "pparsons-eu-west-1"
  subnet_id     = module.vpc.private_subnets[0]

  security_groups = [aws_security_group.mongo_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y docker
              sudo service docker start
              sudo usermod -a -G docker ec2-user
              sudo curl -L https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-amazon2-6.0.4.tgz -o mongodb.tgz
              tar -xvzf mongodb.tgz
              sudo mv mongodb-linux-x86_64-amazon2-6.0.4 /usr/local/mongodb
              sudo ln -s /usr/local/mongodb/bin/* /usr/local/bin/
              mkdir -p ~/data/db
              mongod --dbpath ~/data/db --bind_ip 0.0.0.0 &
              EOF

  tags = {
    Name = "mongodb-instance"
  }
}

output "eks_cluster_endpoint" {
  description = "EKS Cluster Endpoint"
  value       = module.eks.cluster_endpoint
}

output "mongodb_instance_public_ip" {
  description = "MongoDB Instance Public IP"
  value       = aws_instance.mongodb.public_ip
}

