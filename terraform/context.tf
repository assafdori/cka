locals {
  region = "us-west-2"
  cluster_name = module.eks.cluster_name
  cluster_alias = "amazon-cluster"
}

output "configure_kubectl" {
  description = "Command to configure kubectl"
  value = <<-EOT
    aws eks --region ${local.region} update-kubeconfig --name ${local.cluster_name} --alias ${local.cluster_alias}
EOT
}
