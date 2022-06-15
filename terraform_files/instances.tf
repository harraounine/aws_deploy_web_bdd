 ################### INSTANCES ###################################

# create  network interface  to attach ec2  instances

resource "aws_network_interface" "link1" {
  subnet_id       = aws_subnet.my_app-subnet[count.index].id
  security_groups = [aws_security_group.App_SG.id]
  private_ips     = [var.web_instance_ips[count.index]]
}


#Create my WEB1 and WEB2 Instance

resource "aws_instance" "web" {
  ami           = "ami-0022f774911c1d690"
  instance_type = "t2.micro"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.link1[count.index].id
  }

  tags = {
    Name = var.webserver_instance[count.index]
  }

  user_data = filebase64("./instances.sh")
  count     = 2
}
