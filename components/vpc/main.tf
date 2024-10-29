resource "aws_vpc" "vpcRS" {
  cidr_block = var.vpcRS_cidr
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "subRSa" {
  vpc_id     = aws_vpc.vpcRS.id
  cidr_block = var.subRSa_cidr
  availability_zone = var.AZa

  tags = {
    Name = "${var.project_name}-"
  }
}

resource "aws_subnet" "subRSb" {
  vpc_id     = aws_vpc.vpcRS.id
  cidr_block = var.subRSb_cidr
  availability_zone = var.AZb

  tags = {
    Name = "${var.project_name}-subnetB"
  }
}

resource "aws_redshift_subnet_group" "redshift-sub-gr" {
depends_on = [ aws_subnet.subRSa,aws_subnet.subRSb ]
name       = "${var.project_name}-sub-gr"
subnet_ids = [aws_subnet.subRSa.id, aws_subnet.subRSb.id]
tags = {
    Name = "${var.project_name}-subnet-group"
  }
}

resource "aws_default_security_group" "redshift_security_group" {
  vpc_id = aws_vpc.vpcRS.id
  

  ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  # egress {
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
    tags = {
    Name        = "${var.project_name}-redshift_security_group"
    Description = "redshift access"
  }
}

# resource "aws_default_security_group" "redshift_security_group" {
#   vpc_id = aws_vpc.vpcRS.id

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.vpcRS.id
   tags = {
    Name = "${var.project_name}-igw"
  }
  
}

resource "aws_route_table" "RStable" {
  vpc_id = aws_vpc.vpcRS.id
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = {
    Name = "${var.project_name}-route-igw"
  }
}
resource "aws_route_table_association" "subnet_associationA" {
  subnet_id      = aws_subnet.subRSa.id
  route_table_id = aws_route_table.RStable.id
}
resource "aws_route_table_association" "subnet_associationB" {
  subnet_id      = aws_subnet.subRSb.id
  route_table_id = aws_route_table.RStable.id
}



