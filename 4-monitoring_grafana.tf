# 4-monitoring_grafana.tf

# Crear el namespace explícitamente
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "grafana" {
  name             = "grafana"
  namespace        = "monitoring"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  create_namespace = false
  force_update     = true
  recreate_pods    = true

  depends_on = [kubernetes_namespace.monitoring]

  values = [<<EOF
adminPassword: "admin123"

service:
  type: NodePort
  nodePort: 30091

datasources:
  datasources.yaml:
    apiVersion: 1
    datasources:
      - name: Prometheus
        type: prometheus
        access: proxy
        url: http://prometheus-server.monitoring.svc.cluster.local
        isDefault: true

dashboardProviders:
  dashboardproviders.yaml:
    apiVersion: 1
    providers:
      - name: 'default'
        orgId: 1
        folder: ''
        type: file
        disableDeletion: false
        updateIntervalSeconds: 10
        options:
          path: /var/lib/grafana/dashboards/default

dashboardsConfigMaps:
  default: "grafana-dashboards"

sidecar:
  dashboards:
    enabled: true
    label: grafana_dashboard
    labelValue: "1"

persistence:
  enabled: false
EOF
  ]
}

resource "kubernetes_config_map" "grafana_dashboard" {
  metadata {
    name      = "grafana-dashboards"
    namespace = "monitoring"
    labels = {
      grafana_dashboard = "1"
    }
  }

  depends_on = [kubernetes_namespace.monitoring]

  data = {
    "node-exporter-full.json" = file("${path.module}/dashboards/1860-node-exporter-full.json")
  }
}
