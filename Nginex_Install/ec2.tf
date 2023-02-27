resource "aws_instance" "lab_instance" {
  ami           = "ami-0cc87e5027adcdca8"
  instance_type = "t2.micro"
  key_name      = "Lab1_KP"

  subnet_id                   = aws_subnet.lab_subnet.id
  vpc_security_group_ids      = [aws_security_group.lab_sg.id]
  associate_public_ip_address = "true"

  connection {                          //the connection block is the means in which terraform will connect to the instance after it is created
    type        = "ssh"                 //It is going to ssh(basically use command line) to connect to it 
    user        = "ec2-user"            //ec2-user is the user
    private_key = file("./Lab1_KP.pem") //we switched the password block with the private_key (key pair) we made in AWS and specify the "file path"
    host        = self.public_ip        //this command uses the ec2 instances public ip that it receives upon creation 
  }

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install -y nginx1", //once terraform has logged into the ec2 instance it will next do whats in this block. so we want it to
      "sudo systemctl start nginx"                  //install the webserver and then start the webserver
    ]
  }

  tags = {
    Name = "lab1"
  }
}