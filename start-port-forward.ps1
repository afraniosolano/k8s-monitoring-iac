Start-Process powershell -ArgumentList 'kubectl port-forward service/nginx-service 8080:80 -n mundose'
Start-Process powershell -ArgumentList 'kubectl port-forward service/prometheus-server 30090:80 -n monitoring'
Start-Process powershell -ArgumentList 'kubectl port-forward service/grafana 30091:80 -n monitoring'
