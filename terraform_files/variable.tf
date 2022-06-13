variable "regions" {
  type    = string
  default = "us-east-1"
}
variable "zones" {
  type    = list(any)
  default = ["us-east-1a" , "us-east-1b"]

}
variable "vpcblock" {
  type    = string
  default = "10.0.0.0/16"
}
variable "publicblock" {
  type    = list(any)
  default = ["10.0.1.0/24", "10.0.2.0/24"]

}
variable "privateblock" {
  type    = list(any)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "ports" {
  type    = list(number)
  default = [22, 80, 443, 3306]
}

variable "Apptags" {
  type    = list(any)
  default = ["Appsubnet1", "Appsubnet2"]

}
variable "Dbtags" {
  type    = list(any)
  default = ["dbsubnet1", "dbsubnet2"]

}

variable "routetable_app" {
  type    = list(any)
  default = ["table-app1", "table-app2"]

}
variable "routetable_db" {
  type    = list(any)
  default = ["table-db1", "table-db2"]

}
variable "web_instance_ips" {
  type    = list(any)
  default = ["10.0.1.10", "10.0.2.10"]

}
variable "webserver_instance" {
  type    = list(any)
  default = ["webserver1", "webserver2"]
}

variable "instances_list" {
  type = map(any)
  default = {
    "ami_id"         = "ami-0022f774911c1d690"
    "instance_types" = "t2.micro"
    keys             = ""
  }

}

output "webserver1" {
  value = aws_instance.web[0].public_ip
}
output "webserver2" {
  value = aws_instance.web[1].public_ip
}