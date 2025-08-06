# k8s.tf

resource "kubernetes_namespace" "mundose" {
  # Espera a que el clúster de Minikube esté creado antes de aplicar este recurso.
  depends_on = [minikube_cluster.cluster]

  metadata {
    name = "k8s-ns-by-tf"
  }
}

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
        /*
         * Configuramos el contenedor de nginx para servir una página
         * personalizada. Se monta el ConfigMap `nginx_index` como volumen
         * en `/usr/share/nginx/html`, lo que sustituye la página por defecto
         * de Nginx por nuestro propio `index.html`.
         */
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

/*
 * ConfigMap que contiene el contenido de la página web. Aquí definimos
 * un `index.html` con el texto "HOLA MUNDOSE". Este ConfigMap será
 * montado en el contenedor nginx para reemplazar la página de inicio
 * por defecto.
 */
resource "kubernetes_config_map" "nginx_index" {
  metadata {
    name      = "nginx-index"
    namespace = kubernetes_namespace.mundose.metadata[0].name
  }
  data = {
    "index.html" = file("${path.module}/files/index.html")
  }
}

/*
 * Servicio de tipo NodePort que expone el deployment de nginx. El puerto
 * del clúster (80) se mapea a un puerto alto (30080) en el nodo. Puedes
 * acceder a la aplicación mediante `http://<IP-del-nodo>:30080`. En Minikube,
 * puedes obtener la IP del nodo con `minikube ip` o utilizar
 * `minikube service nginx-service --url` para abrir un túnel.
 */
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
