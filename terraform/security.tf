# ==========================================
# Data Sources - Security Groups
# ==========================================
data "aws_security_group" "web_sg" {
  filter {
    name   = "group-name"
    values = [var.web_sg_name]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.lab_vpc.id]
  }
}

# ==========================================
# Application Load Balancer Security Group
# ==========================================
resource "aws_security_group" "alb_sg" {
  name        = "ALB-Security-Group"
  description = "Permite trafico HTTP entrante al Load Balancer desde Internet"
  vpc_id      = data.aws_vpc.lab_vpc.id

  ingress {
    description = "HTTP desde cualquier origen"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Permitir todo el trafico saliente"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "ALB-Security-Group" }
}

# ==========================================
# Reglas Cruzadas
# ==========================================
# Permite a las instancias web recibir tráfico exclusivo desde el ALB
resource "aws_security_group_rule" "allow_alb_to_instances_http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = data.aws_security_group.web_sg.id
  source_security_group_id = aws_security_group.alb_sg.id
  description              = "Ingreso HTTP restringido desde el ALB"
}