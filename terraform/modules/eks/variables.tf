variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_role_arn" {
  description = "ARN of the role for EKS cluster"
  type        = string
}

variable "node_group_name" {
  description = "Name of the EKS node group"
  type        = string
}

variable "node_role_arn" {
  description = "ARN of the role for EKS nodes"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets for the EKS cluster"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for the EKS cluster"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for the EKS cluster"
  type        = string
}

variable "server_host" {
  description = "Host header for the server application"
  type        = string
}

variable "desired_capacity" {
  description = "Desired capacity for the EKS node group"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum size for the EKS node group"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "Minimum size for the EKS node group"
  type        = number
  default     = 1
}
