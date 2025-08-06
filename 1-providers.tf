# providers.tf
terraform {
  required_providers {
    minikube = {
      source  = "scott-the-programmer/minikube"
      version = ">=0.5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.11.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.13.1"
    }
  }
}


provider "minikube" {
  kubernetes_version = "v1.30.0"
}

# El proveedor Kubernetes utiliza las salidas del clúster creado por minikube.

provider "kubernetes" {
  host                   = minikube_cluster.cluster.host
  client_certificate     = minikube_cluster.cluster.client_certificate
  client_key             = minikube_cluster.cluster.client_key
  cluster_ca_certificate = minikube_cluster.cluster.cluster_ca_certificate
}

provider "helm" {
  kubernetes = {
    host                   = minikube_cluster.cluster.host
    client_certificate     = minikube_cluster.cluster.client_certificate
    client_key             = minikube_cluster.cluster.client_key
    cluster_ca_certificate = minikube_cluster.cluster.cluster_ca_certificate
  }
}





# Crea el clúster local con el driver Docker y activa algunos addons.
resource "minikube_cluster" "cluster" {
  vm      = false
  driver  = "docker"
  cni     = "bridge"
  addons  = [
    "dashboard",
    "default-storageclass",
    "ingress",
    "storage-provisioner"
  ]
}

