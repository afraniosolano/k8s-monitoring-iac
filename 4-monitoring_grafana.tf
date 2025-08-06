resource "helm_release" "grafana" {
  name       = "grafana"
  namespace  = "monitoring"
repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "7.3.10"

  create_namespace = true

  values = [<<EOF
service:
  type: NodePort
  nodePort: 30091
adminPassword: "admin123"
persistence:
  enabled: false
EOF
  ]
}