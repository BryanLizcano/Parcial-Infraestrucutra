terraform {
  required_version = ">= 1.3.0"

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