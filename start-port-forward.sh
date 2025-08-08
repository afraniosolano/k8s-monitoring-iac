#!/bin/bash
gnome-terminal -- kubectl port-forward service/nginx-service 8080:80 -n mundose &
gnome-terminal -- kubectl port-forward service/prometheus-server 30090:80 -n monitoring &
gnome-terminal -- kubectl port-forward service/grafana 30091:80 -n monitoring &
