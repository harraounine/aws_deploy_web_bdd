################### INSTANCES ###################################

# create  network interface  to attach ec2  instances
resource "aws_network_interface" "link1" {
  subnet_id   = aws_subnet.my_app-subnet[count.index].id
  private_ips = [var.web_instance_ips[count.index]]
  count       = 2
}
resource "aws_network_interface_attachment" "intf_attach1" {
  network_interface_id = aws_network_interface.link1[count.index].id
  device_index         = 0
  instance_id          = aws_instance.web[count.index].id
  count                = 2
}

#Create my WEB1 and WEB2 Instance
resource "aws_instance" "web" {
  ami               = "ami-000cbce3e1b899ebd"
  instance_type     = "t2.micro"
  key_name          = "Web-key"
  subnet_id         = aws_subnet.my_app-subnet[count.index].id
  security_groups   = [aws_security_group.App_SG.id]
  availability_zone = element(var.zones,count.index)
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
