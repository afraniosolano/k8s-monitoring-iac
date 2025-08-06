resource "helm_release" "prometheus" {
  name       = "prometheus"
  namespace  = "monitoring"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = "25.8.0"

  create_namespace = true

  values = [<<EOF
alertmanager:
  enabled: true
server:
  service:
    type: NodePort
    nodePort: 30090
EOF
  ]
}