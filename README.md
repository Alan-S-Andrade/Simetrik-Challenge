# Simetrik challenge

Instruciones para Ubuntu

## Python gRPC apps

## Basic Calculator

The server handles three different RPC methods: Add, Subtract, and Multiply. The client calls each of these methods, providing two numbers and printing the results of the operations. 

## Installation

First install terraform, docker, and the Kubernetes CLI:
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli#install-cli,
https://docs.docker.com/engine/install/ubuntu/,
https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

Then add your AWS credentials:
```bash
aws configure
```

Run the following lines in your terminal:

```bash
pip install grpcio grpcio-tools
python -m grpc_tools.protoc -I. --python_out=. --grpc_python_out=. pyApps/service.proto
```

Run the server application:
```bash
python pyApps/server/server.py
```

Run the client application:
```bash
python pyApps/client/client.py
```

## Terraform modules

## Architecture
```lua
+---------------------------------------------+
|                     VPC                     |
|                                             |
| +-------------+   +---------------------+   |
| | Public Sub  |   | Private Sub         |   |
| | (Server LB) |   | (EKS Cluster Nodes) |   |
| +-------------+   +---------------------+   |
|                                             |
+---------------------------------------------+
```
## Configuration

Create an S3 bucket for storing the Terraform state.
Create a DynamoDB table for state locking

```bash
aws s3api create-bucket --bucket simetrik-terraform-state-bucket --region us-east-1
aws dynamodb create-table --table-name terraform-lock --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
```

Build terraform backend
```bash
terraform init
terraform plan
terraform apply
```

## CI/CD

Create a CodeBuild Project in the AWS console. Choose "Use a buildspec file" and make sure the filename is buildspec.yml. Manually start a build or set up triggers to automatically start builds based on events

## Deployment Guide

After the infrastructure is set up, deploy the server and client applications to the EKS cluster. You can use the Kubernetes manifests to create the deployments and services for these applications:

First build and push the docker images to the registry:

```bash
sh build_and_push_docker_img.sh
```

Then apply the Kubernetes manifests to the EKS cluster.

```bash
kubectl apply -f pyApps/server_deployment.yaml
kubectl apply -f pyApps/client_deployment.yaml
```

## Networking explication

The networking module creates a VPC with public and private subnets. The public subnets are configured with an internet gateway to allow internet access, while the private subnets host the EKS cluster nodes. Security groups are set up to allow necessary traffic for the applications.

The EKS module sets up an EKS cluster in the private subnets and creates an Application Load Balancer (ALB) in the public subnets exposing the server application. The ALB routes traffic to the server application based on the host header.

This setup ensures that the client application can communicate with the server application within the EKS cluster, and the server application is accessible via the ALB.
