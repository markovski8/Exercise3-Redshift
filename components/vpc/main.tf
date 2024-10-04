resource "aws_vpc" "vpcRS" {
  cidr_block = var.vpcRS_cidr
}

resource "aws_subnet" "subRSa" {
  vpc_id     = aws_vpc.vpcRS.id
  cidr_block = var.subRSa_cidr
  availability_zone = var.AZa

  tags = {
    Name = "subnetA"
  }
}

resource "aws_subnet" "subRSb" {
  vpc_id     = aws_vpc.vpcRS.id
  cidr_block = var.subRSb_cidr
  availability_zone = var.AZb

  tags = {
    Name = "subnetB"
  }
}

resource "aws_db_subnet_group" "subGroupRS" {
  name       = "rds-db-subnet-group"
  subnet_ids = [aws_subnet.subRSa,aws_subnet.subRSb]  

  tags = {
    Name = "subGroup"
  }
}

resource "aws_security_group" "sgRS" {
  name        = "RS-security-group"
  description = "RS security group"
  vpc_id      = aws_vpc.vpcRS.id
  

  ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = var.vpcRS_cidr  
    security_groups = [aws_security_group.sgRS.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
