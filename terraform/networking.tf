# ==========================================
# Data Sources - Red Preexistente
# ==========================================
data "aws_vpc" "lab_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_route_table" "public_rt" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.lab_vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["Work Public Route Table"]
  }
}

# 1. Filtramos para estar 100% seguros de que agarramos la pública real
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.lab_vpc.id]
  }
  filter {
    name   = "map-public-ip-on-launch"
    values = ["true"] # Filtro clave añadido
  }
}

# 2. Leemos las propiedades exactas de esa subred pública de AWS
data "aws_subnet" "existing_public" {
  id = data.aws_subnets.public.ids[0]
}

# 3. Creamos nuestra subred garantizando una Zona de Disponibilidad DIFERENTE
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = data.aws_vpc.lab_vpc.id
  cidr_block              = "10.0.1.0/24"
  
  availability_zone       = data.aws_subnet.existing_public.availability_zone == "${var.aws_region}a" ? "${var.aws_region}b" : "${var.aws_region}a"
  
  map_public_ip_on_launch = true

  tags = { Name = "Work Public Subnet 2" }
}

# ==========================================
# Creación de Subredes Adicionales
# ==========================================
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = data.aws_vpc.lab_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = { Name = "Work Public Subnet 2" }
}

resource "aws_route_table_association" "public_subnet_2_assoc" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = data.aws_route_table.public_rt.id
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = data.aws_vpc.lab_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = false

  tags = { Name = "Work Private Subnet 1" }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = data.aws_vpc.lab_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = false

  tags = { Name = "Work Private Subnet 2" }
}