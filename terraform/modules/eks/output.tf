output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "node_group_name" {
  value = aws_eks_node_group.this.node_group_name
}

output "load_balancer_dns_name" {
  value = aws_lb.this.dns_name
}
