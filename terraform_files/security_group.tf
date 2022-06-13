#Create a Security Group for web server

resource "aws_security_group" "App_SG" {
  name        = "App_SG"
  description = "Allow internet inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id
  #cidr_blocks = ["41.79.199.47/32"] this  be my ip addres of wifi public ip  that  my your laptop can  access to  ec2 instances and databse at  security group

  ingress {
    description = "SSH"
    from_port   = var.ports[0]
    to_port     = var.ports[0]
    protocol    = "tcp"
    cidr_blocks = ["41.79.199.47/32"]
  }
  ingress {
    description = "HTTPS"
    from_port   = var.ports[2]
    to_port     = var.ports[2]
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = var.ports[1]
    protocol    = "tcp"
    to_port     = var.ports[1]
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = var.ports[3]
    protocol    = "tcp"
    to_port     = var.ports[3]
    cidr_blocks = ["41.79.199.47/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


#Create a Security Group for DB server

resource "aws_security_group" "DB_SG" {
  name        = "DB_SG"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description     = "SSH"
    from_port       = var.ports[0]
    to_port         = var.ports[0]
    protocol        = "tcp"
    security_groups = [aws_security_group.App_SG.id]
  }
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description     = "tcp"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.App_SG.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



# create security  group for load balancer 
resource "aws_security_group" "LB" {
  name        = "LB"
  description = "for load balancer traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "HTTPS"
    from_port   = var.ports[2]
    to_port     = var.ports[2]
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = var.ports[1]
    protocol    = "tcp"
    to_port     = var.ports[1]
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

