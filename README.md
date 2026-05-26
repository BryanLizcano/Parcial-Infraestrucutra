# 🚀 Infraestructura Resiliente: Auto Scaling & Load Balancing (AWS)

Este proyecto implementa Infraestructura como Código (IaC) con **Terraform** para desplegar una arquitectura altamente disponible en Amazon Web Services (AWS), diseñada originalmente para el laboratorio de Gestión de Infraestructura. 

El entorno garantiza resiliencia delegando la distribución de tráfico a un **Application Load Balancer (ALB)** y automatizando la creación/destrucción de nodos EC2 mediante un **Auto Scaling Group (ASG)** basado en el consumo de CPU.

## 🏗️ Arquitectura de la Solución

- **VPC Híbrida**: Integración con redes preexistentes del entorno sandbox.
- **Application Load Balancer**: Punto de entrada expuesto a Internet que distribuye peticiones HTTP en múltiples Zonas de Disponibilidad (AZ).
- **Auto Scaling Group**: Despliegue dinámico de instancias Amazon Linux 2023 con escalado configurado al 60% de uso de CPU.
- **Seguridad**: Reglas restrictivas. Las instancias EC2 solo aceptan tráfico proveniente explícitamente del Security Group del ALB.

## 📂 Estructura del Repositorio

| Archivo | Descripción |
|---------|-------------|
| `provider.tf` | Configuración base y etiquetas globales dinámicas. |
| `networking.tf` | Ingesta de la red preexistente y aprovisionamiento de subredes Multi-AZ. |
| `security.tf` | Reglas de firewall virtual (Ingress/Egress) restrictivas. |
| `compute.tf` | Orquestación del ALB, Target Group, Launch Template y Auto Scaling. |
| `variables.tf` | Parametrización centralizada del código. |
| `outputs.tf` | Puntos de enlace y telemetría arrojada post-despliegue. |
| `user_data.sh` | Script bootstrap que instala Apache y recupera metadata via IMDSv2. |

## ⚙️ Requisitos y Despliegue

1. **Pre-requisitos**: Poseer credenciales activas del sandbox (AWS Academy/Educate) configuradas localmente vía AWS CLI (`aws configure`).
2. **Inicializar**:
   ```bash
   terraform init