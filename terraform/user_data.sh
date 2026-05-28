#!/bin/bash
# Actualizar sistema e instalar dependencias
dnf update -y
dnf install -y docker git jq

# Iniciar Docker
systemctl enable docker
systemctl start docker

# Obtener metadatos de la instancia (para inyectarlos a tu app)
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)

# Clonar tu repositorio (Reemplaza la URL con la tuya)
# Si es privado, usa un Personal Access Token de GitHub en la URL
git clone https://github.com/BryanLizcano/Parcial-Infraestrucutra.git /tmp/repo

# Construir la imagen Docker usando tu Dockerfile
cd /tmp/repo/app
docker build -t demo-app .

# Ejecutar el contenedor en el puerto 80, pasando las variables de entorno de tu app
docker run -d \
  --network host \
  --name web-app \
  -e PORT=80 \
  -e INSTANCE_NAME=$INSTANCE_ID \
  demo-app