@echo off
start cmd /k "kubectl port-forward service/nginx-service 8080:80 -n mundose"
start cmd /k "kubectl port-forward service/prometheus-server 30090:80 -n monitoring"
start cmd /k "kubectl port-forward service/grafana 30091:80 -n monitoring"
