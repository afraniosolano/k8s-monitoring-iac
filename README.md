# k8s-monitoring-iac

Automatización del despliegue de un stack de monitorización completo con **Prometheus** y **Grafana** en un clúster de **Kubernetes** usando **Terraform** y **Helm**.  
Este proyecto aplica el enfoque de **Infrastructure as Code (IaC)** para asegurar consistencia, repetibilidad y automatización en la configuración del entorno de observabilidad.

---

## 📌 Objetivo del Proyecto

Implementar una infraestructura local reproducible que incluya:

- Clúster Kubernetes funcional (Minikube con driver Docker).
- Aplicación Nginx personalizada.
- Stack de monitorización con Prometheus y Grafana.
- Namespaces dedicados para separar componentes.
- Configuración automática de dashboards y datasources.

---

## 📁 Estructura del Proyecto

```bash
.
├── 1-providers.tf               # Configuración de Terraform y proveedores
├── 2-k8s.tf                     # Despliegue de Nginx con ConfigMap y Service
├── 3-monitoring_prometheus.tf   # Instalación de Prometheus vía Helm
├── 4-monitoring_grafana.tf      # Instalación de Grafana vía Helm
├── dashboards/                  # Dashboards JSON para Grafana
├── files/                       # Archivos HTML para la app Nginx
├── start-port-forward.ps1        # Script PowerShell para acceso rápido a servicios
├── start-port-forward.bat        # Script CMD para Windows
├── start-port-forward.sh         # Script Bash para Linux/macOS
└── README.md                     # Documentación del proyecto
```

---

## 🚀 Requisitos Previos

- Terraform ≥ 1.0.0
- Helm ≥ 3.x
- Minikube ≥ 1.30.0 (driver Docker)
- kubectl configurado (`~/.kube/config`)
- Acceso a internet para descargar charts de Helm

---

## 🛠️ Instrucciones de Uso

### 1️⃣ Clonar repositorio

```bash
git clone git@github.com:afraniosolano/k8s-monitoring-iac.git
cd k8s-monitoring-iac
```

### 2️⃣ Inicializar Terraform

```bash
terraform init
```

### 3️⃣ Revisar el plan

```bash
terraform plan
```

### 4️⃣ Aplicar cambios

```bash
terraform apply
```

---

## 📊 Componentes y Configuración

### **1. 1-providers.tf**

- Define providers `minikube`, `kubernetes` y `helm`.
- Configura Minikube sin VM (`driver = docker`).
- Habilita addons: dashboard, storageclass, ingress.

### **2. 2-k8s.tf**

- Crea namespace `mundose`.
- Despliega `nginx` con 2 réplicas y HTML personalizado vía ConfigMap.
- Expone servicio en NodePort `30080`.

### **3. 3-monitoring_prometheus.tf**

- Instala Prometheus desde `prometheus-community/helm-charts`.
- Expone en NodePort `30090`.

### **4. 4-monitoring_grafana.tf**

- Crea namespace `monitoring`.
- Instala Grafana desde `grafana/helm-charts`.
- Configura datasource Prometheus automáticamente.
- Carga dashboards JSON desde `dashboards/`.
- Expone en NodePort `30091`.

---

## 📡 Acceso a Servicios

| Servicio      | Namespace            | NodePort | Port-Forward | URL Local              | Credenciales     |
| ------------- | -------------------- | -------- | ------------ | ---------------------- | ---------------- |
| Nginx         | mundose              | 30080    | 8080         | http://localhost:8080  | N/A              |
| Prometheus    | monitoring           | 30090    | 30090        | http://localhost:30090 | N/A              |
| Grafana       | monitoring           | 30091    | 30091        | http://localhost:30091 | admin / admin123 |
| Dashboard K8s | kubernetes-dashboard | N/A      | 8080         | http://localhost:8080  | Token de K8s     |

---

## ⚡ Automatizar Port-Forward

Después de `terraform apply`, puedes abrir los servicios con los scripts incluidos:

### Windows PowerShell

```powershell
./start-port-forward.ps1
```

### Windows CMD

```cmd
start-port-forward.bat
```

### Linux/macOS

```bash
chmod +x start-port-forward.sh
./start-port-forward.sh
```

---

## 🔄 Flujo de Despliegue

1. **Minikube**: creación del clúster y habilitación de addons.
2. **Namespaces**: `mundose` para Nginx y `monitoring` para Prometheus/Grafana.
3. **Nginx**: deployment + configmap + service.
4. **Prometheus**: instalación vía Helm.
5. **Grafana**: instalación vía Helm + dashboards y datasources.

---

## 🎯 Casos de Uso

- Desarrollo local con monitoreo.
- Entornos de testing y QA reproducibles.
- Demos de DevOps con stack completo.
- Aprendizaje práctico de Terraform, Kubernetes, Helm, Prometheus y Grafana.

---

## 🧼 Limpieza de Recursos

```bash
terraform destroy
```

---

## 📜 Licencia

MIT License — Uso libre con atribución.
