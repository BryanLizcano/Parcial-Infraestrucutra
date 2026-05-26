# ==========================================
# Data Sources - Compute
# ==========================================
data "aws_iam_instance_profile" "lab_profile" {
  name = var.instance_profile_name
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}

# ==========================================
# Application Load Balancer & Target Group
# ==========================================
resource "aws_lb_target_group" "lab_tg" {
  name        = var.target_group_name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.lab_vpc.id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 5
    interval            = 30
    timeout             = 5
    matcher             = "200"
  }
}

resource "aws_lb" "lab_alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]

  # Distribución del ALB en múltiples Zonas de Disponibilidad
  subnets = [
    data.aws_subnets.public.ids[0],
    aws_subnet.public_subnet_2.id
  ]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.lab_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lab_tg.arn
  }
}

# ==========================================
# Launch Template
# ==========================================
resource "aws_launch_template" "lab_lt" {
  name        = var.launch_template_name
  description = "Plantilla de despliegue automatizado para instancias EC2"

  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type
  key_name      = var.key_pair_name

  iam_instance_profile {
    name = data.aws_iam_instance_profile.lab_profile.name
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [data.aws_security_group.web_sg.id]
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 8
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }

  monitoring {
    enabled = true # Requerido para métricas precisas de escalado
  }

  user_data = filebase64("${path.module}/user_data.sh")
}

# ==========================================
# Auto Scaling Group & Políticas
# ==========================================
resource "aws_autoscaling_group" "lab_asg" {
  name = var.asg_name

  launch_template {
    id      = aws_launch_template.lab_lt.id
    version = aws_launch_template.lab_lt.latest_version
  }

  vpc_zone_identifier = [
    data.aws_subnets.public.ids[0],
    aws_subnet.public_subnet_2.id
  ]

  min_size                  = var.asg_min_size
  desired_capacity          = var.asg_desired_capacity
  max_size                  = var.asg_max_size
  target_group_arns         = [aws_lb_target_group.lab_tg.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 120
  wait_for_capacity_timeout = "10m"
  metrics_granularity       = "1Minute"

  enabled_metrics = [
    "GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity",
    "GroupInServiceInstances", "GroupPendingInstances",
    "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances",
  ]

  tag {
    key                 = "Name"
    value               = "Lab Instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "lab_scaling_policy" {
  name                   = var.scaling_policy_name
  autoscaling_group_name = aws_autoscaling_group.lab_asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = var.scaling_cpu_target
  }
}