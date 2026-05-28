terraform {
  required_version = ">= 1.3.0"

  # Configuración del Backend Remoto para centralizar el tfstate
  backend "s3" {
    bucket         = "upb-parcial-backend-terraform-bryan" # Nombre exacto de tu bucket creado
    key            = "global/s3/terraform.tfstate"         # Ruta del archivo de estado dentro del bucket
    region         = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  # Etiquetas globales para auditoría y organización
  default_tags {
    tags = {
      Environment = "Sandbox-Lab"
      Project     = "Escalado-Automatico"
      ManagedBy   = "Terraform"
      Course      = "Gestion de Infraestructura"
    }
  }
}