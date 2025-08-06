# k8s-monitoring-iac

Automatización del despliegue de un stack de monitoreo con **Prometheus** y **Grafana** en un clúster de **Kubernetes** usando **Terraform** y **Helm**. Este proyecto aplica el enfoque de **Infrastructure as Code (IaC)** para asegurar consistencia, repetibilidad y automatización en la configuración del entorno de observabilidad.

---

## 📁 Estructura del proyecto

```bash
.
├── 1-providers.tf                # Configuración de los providers Helm y Kubernetes
├── 2-k8s.tf                      # Recursos base: namespace y service accounts
├── 3-monitoring_prometheus.tf   # Instalación de Prometheus vía Helm
├── 4-monitoring_grafana.tf      # Instalación de Grafana vía Helm
└── README.md                     # Documentación del proyecto
```

---

## 🚀 Requisitos previos

- Terraform ≥ 1.0.0
- Helm ≥ 3.x
- Un clúster Kubernetes activo y accesible (ej: Minikube, MicroK8s, EKS, etc.)
- Archivo de configuración kubeconfig en `~/.kube/config`

---

## 🛠️ Instrucciones de uso

### 1. Clona este repositorio

```bash
git clone https://github.com/tuusuario/k8s-monitoring-iac.git
cd k8s-monitoring-iac
```

### 2. Inicializa Terraform

```bash
terraform init
```

### 3. Revisa el plan de ejecución

```bash
terraform plan
```

### 4. Aplica la infraestructura

```bash
terraform apply
```

---

## 🧩 Detalle de los componentes

### ✅ `1-providers.tf`

- Define los providers `helm` y `kubernetes`
- Usa el archivo local `~/.kube/config` para autenticarse con el clúster

### ✅ `2-k8s.tf`

- Crea el `namespace monitoring`
- Configura una `ServiceAccount` y `RoleBinding` (legacy de Helm 2)

### ✅ `3-monitoring_prometheus.tf`

- Despliega Prometheus desde `prometheus-community/helm-charts`
- Expone Prometheus por `NodePort` en el puerto `30090`

### ✅ `4-monitoring_grafana.tf`

- Despliega Grafana desde `grafana/helm-charts`
- Expone Grafana por `NodePort` en el puerto `30030`
- Configura usuario y contraseña de acceso
- Dashboard sidecar habilitado

---

## 📡 Acceso a los servicios

Una vez aplicado, puedes acceder desde tu navegador:

- **Grafana**: http://<IP_DEL_NODO>:30030
- **Prometheus**: http://<IP_DEL_NODO>:30090

> ⚠️ Asegúrate de que tu clúster permite el acceso externo a estos puertos o ajusta a `LoadBalancer` si estás en la nube.

---

## 🧼 Eliminación de recursos

Para destruir toda la infraestructura:

```bash
terraform destroy
```

---

## 📘 Licencia

Este proyecto está licenciado bajo MIT. Puedes modificar y reutilizar libremente con atribución.

---

## 🙌 Créditos

Inspirado en las mejores prácticas de IaC con Terraform, Helm y Kubernetes.
