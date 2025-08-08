# 2-k8s.tf

# Namespace
resource "kubernetes_namespace" "mundose" {
  depends_on = [minikube_cluster.cluster]

  metadata {
    name = "mundose"
  }
}

# ConfigMap para archivo index.html
resource "kubernetes_config_map" "nginx_index" {
  metadata {
    name      = "nginx-index"
    namespace = kubernetes_namespace.mundose.metadata[0].name
  }
  data = {
    "index.html" = file("${path.module}/files/index.html")
  }
}

# Deployment de Nginx
resource "kubernetes_deployment" "mundose" {
  depends_on = [kubernetes_namespace.mundose, minikube_cluster.cluster]

  metadata {
    name      = "terraform-mundose"
    namespace = kubernetes_namespace.mundose.metadata[0].name
    labels = {
      test = "MundoseApp"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        test = "MundoseApp"
      }
    }

    template {
      metadata {
        labels = {
          test = "MundoseApp"
        }
      }

      spec {
        container {
          name  = "mundose"
          image = "nginx:1.21.6"

          volume_mount {
            name       = "html"
            mount_path = "/usr/share/nginx/html"
          }
        }

        volume {
          name = "html"
          config_map {
            name = kubernetes_config_map.nginx_index.metadata[0].name
            items {
              key  = "index.html"
              path = "index.html"
            }
          }
        }
      }
    }
  }
}

# Servicio NodePort para acceder al Nginx
resource "kubernetes_service" "nginx_service" {
  metadata {
    name      = "nginx-service"
    namespace = kubernetes_namespace.mundose.metadata[0].name
  }
  spec {
    selector = {
      test = "MundoseApp"
    }
    port {
      port        = 80
      target_port = 80
      node_port   = 30080
    }
    type = "NodePort"
  }

  depends_on = [kubernetes_deployment.mundose]
}
