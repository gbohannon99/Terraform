//This project is intended to help learn the process of creating a VPC, Subnet, SG, AWS Instance, and installing
//  a docker image in the EC2 instance. 

//Creating a VPC, with a CIDR Block of 10.0.0.0/16
resource "aws_vpc" "lab_vpc" {

  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Lab1"
  }

}
//Next Creating a public subnet and attaching it to the VPC via vpc_id
//Put the "map_public_ip_on_launch" argument to make sure instances launched into
//  the subnet are given a public Ip Address
resource "aws_subnet" "lab_subnet" {
  vpc_id     = aws_vpc.lab_vpc.id
  cidr_block = "10.0.1.0/24"

  map_public_ip_on_launch = "true"

  tags = {
    "Name" = "Lab1"
  }
}

//Next I created an Internet Gateway to allow the applicaitons to have a way to connect to the internet
//  Attached the internet Gateway via the vpc_id
resource "aws_internet_gateway" "lab_gw" {
  vpc_id = aws_vpc.lab_vpc.id

  tags = {
    "Name" = "lab1"
  }
}

//I then created a route table to create routes to the Internet gateway
//  and the route table. (to route internet traffic through gateway)
resource "aws_route_table" "lab_public_rt" {
  vpc_id = aws_vpc.lab_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab_gw.id
  }


}

//This assocaitation to to connect the public subnet with the route table
resource "aws_route_table_association" "lab_route_as" {
  subnet_id      = aws_subnet.lab_subnet.id
  route_table_id = aws_route_table.lab_public_rt.id
}


resource "aws_security_group" "lab_sg" {
  name        = "vpc_sg"
  description = "Main VPC secuirty group for lab"
  vpc_id      = aws_vpc.lab_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}