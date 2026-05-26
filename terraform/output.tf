# ==============================================================================
# outputs.tf — Valores relevantes al finalizar el despliegue
# ==============================================================================

output "alb_dns_name" {
  description = "Nombre DNS del Application Load Balancer. Úsalo en el navegador para probar la app."
  value       = aws_lb.lab_alb.dns_name
}

output "alb_arn" {
  description = "ARN del Application Load Balancer."
  value       = aws_lb.lab_alb.arn
}

output "target_group_arn" {
  description = "ARN del Target Group."
  value       = aws_lb_target_group.lab_tg.arn
}

output "asg_name" {
  description = "Nombre del Auto Scaling Group."
  value       = aws_autoscaling_group.lab_asg.name
}

output "launch_template_id" {
  description = "ID de la Launch Template."
  value       = aws_launch_template.lab_lt.id
}

output "ami_used" {
  description = "ID de la AMI de Amazon Linux 2023 utilizada."
  value       = data.aws_ami.amazon_linux_2023.id
}

output "vpc_id" {
  description = "ID de la Lab VPC detectada por data source."
  value       = data.aws_vpc.lab_vpc.id
}

output "public_subnet_ids" {
  description = "IDs de las subredes públicas (donde vive el ALB)."
  value       = data.aws_subnets.public.ids
}

output "private_subnet_ids" {
  description = "IDs de las subredes privadas (donde viven las instancias del ASG)."
  value       = data.aws_subnets.private.ids
}
