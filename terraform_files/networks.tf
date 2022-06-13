# Create VPC 

resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpcblock
  tags = {
    Name = "MY_VPC"
  }
}

#Create internet gateway for server to be connected to internet

resource "aws_internet_gateway" "my_IG" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "MY_IGW"
  }
}

######################## Network ################################
#APP subnet1 and subnet2

resource "aws_subnet" "my_app-subnet" {
  cidr_block              = var.publicblock[count.index]
  vpc_id                  = aws_vpc.my_vpc.id
  map_public_ip_on_launch = true
  availability_zone = element(var.zones,count.index)
  tags = {
    Name = var.Apptags[count.index]
  }
  count = 2
}


#BDD subnet:

resource "aws_subnet" "my_db-subnet" {
  cidr_block        = var.privateblock[count.index]
  vpc_id            = aws_vpc.my_vpc.id
  availability_zone = element(var.zones,count.index)
  tags = {
    Name = var.Dbtags[count.index]
  }
  count = 2
}

#Define routing table (for App)

resource "aws_route_table" "my_route-table" {
  tags = {
    Name = var.routetable_app[count.index]
  }
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_IG.id
  }
  count = 2
}

# create  eip   and  associate with  instancess
resource "aws_eip" "Eip" {
  vpc = true
  depends_on = [
    aws_internet_gateway.my_IG
  ]
  count = 2
}
# create  nat gateway 
resource "aws_nat_gateway" "my_nat" {
  subnet_id         = aws_subnet.my_app-subnet[count.index].id
  allocation_id     = aws_eip.Eip[count.index].id
  connectivity_type = "public"
  depends_on = [
    aws_internet_gateway.my_IG
  ]
  count = 2
}


#Associate App subnet1 and subnet2 with routing table

resource "aws_route_table_association" "App_Route_Association" {
  subnet_id      = aws_subnet.my_app-subnet[count.index].id
  route_table_id = aws_route_table.my_route-table[count.index].id
  count          = 2
}


#Define routing table (for DB)

resource "aws_route_table" "my_route-table2" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat[count.index].id
  }
  tags = {
    "Namw" = var.routetable_db[count.index]
  }
  count = 2
}

# Associate Db subnet and subnet2 with routing table

resource "aws_route_table_association" "Db_Route_Association2" {
  subnet_id      = aws_subnet.my_db-subnet[count.index].id
  route_table_id = aws_route_table.my_route-table2[count.index].id
  count          = 2
}
