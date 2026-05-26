# ==========================================
# Variables Globales
# ==========================================
variable "aws_region" {
  type        = string
  description = "Región de AWS donde se desplegará la infraestructura."
  default     = "us-east-1"
}

# ==========================================
# Red y Seguridad (Sandbox)
# ==========================================
variable "vpc_name" {
  type        = string
  description = "Etiqueta Name de la VPC preexistente del laboratorio."
  default     = "Work VPC"
}

variable "web_sg_name" {
  type        = string
  description = "Nombre del Security Group preexistente para las instancias EC2."
  default     = "Web Security Group"
}

# ==========================================
# Computo y Auto Scaling
# ==========================================
variable "instance_profile_name" {
  type        = string
  description = "Nombre del perfil IAM preexistente con permisos de sesión."
  default     = "LabInstanceProfile"
}

variable "instance_type" {
  type        = string
  description = "Tipo de instancia EC2 a desplegar (ej. t2.micro o t3.micro)."
  default     = "t2.micro"
}

variable "key_pair_name" {
  type        = string
  description = "Nombre del par de claves SSH preexistente."
  default     = "vockey"
}

variable "alb_name" {
  type        = string
  description = "Nombre del Application Load Balancer."
  default     = "LabELB"
}

variable "target_group_name" {
  type        = string
  description = "Nombre del Target Group asociado al ALB."
  default     = "LabGroup"
}

variable "launch_template_name" {
  type        = string
  description = "Nombre de la plantilla de lanzamiento para el ASG."
  default     = "LabConfig"
}

variable "asg_name" {
  type        = string
  description = "Nombre del grupo de Auto Scaling."
  default     = "Lab-Auto-Scaling-Group"
}

# ==========================================
# Políticas de Escalado
# ==========================================
variable "asg_min_size" {
  type        = number
  description = "Cantidad mínima de instancias operativas."
  default     = 2
}

variable "asg_desired_capacity" {
  type        = number
  description = "Cantidad deseada de instancias en estado normal."
  default     = 2
}

variable "asg_max_size" {
  type        = number
  description = "Límite máximo de instancias ante un pico de tráfico."
  default     = 6
}

variable "scaling_cpu_target" {
  type        = number
  description = "Umbral de CPU (%) para disparar el escalado horizontal."
  default     = 60
}

variable "scaling_policy_name" {
  type        = string
  description = "Nombre descriptivo para la política de Target Tracking."
  default     = "LabScalingPolicy"
}