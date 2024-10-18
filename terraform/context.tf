locals {
  region = "us-east-1"
  cluster_name = module.eks.cluster_name
}

output "configure_kubectl" {
  description = "Command to configure kubectl"
  value = <<-EOT
    aws eks --region ${local.region} update-kubeconfig --name ${local.cluster_name} --alias "amazon-cluster"
EOT
}
