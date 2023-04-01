/* We need to generate a key pair in order to gain access to our EC2 instance. I am going to use a RSA key rather than a ED25519 Key as I am more familar with RSA
    We will run the following commands in the terminal to generate a key pair:
      1) ssh-keygen -t RSA
      2) next copy the path and rename the key as follows C:\Users\Griffin Bohannon/.ssh/devkey
      3) dont bother with a pass phrase
      4) you can then run ls ~/.ssh  to view the directory and check if the key was correctly placed 

*/In order to utilize this key pair we are going to use the aws_key_pair resource block

resource "aws_key_pair" "lab_kp" {
  key_name   = "lab1key"
  public_key = file("~/.ssh/lab1key.pub")
}


resource "aws_instance" "lab_instance" {
  ami           = "ami-0cc87e5027adcdca8"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.lab_kp.id

  subnet_id                   = aws_subnet.lab_subnet.id
  vpc_security_group_ids      = [aws_security_group.lab_sg.id]
  associate_public_ip_address = "true"

  connection {                           //the connection block is the means in which terraform will connect to the instance after it is created
    type        = "ssh"                  //It is going to ssh(basically use command line) to connect to it 
    user        = "ec2-user"             //ec2-user is the user
    private_key = aws_key_pair.lab_kp.id //we switched the password block with the private_key (key pair) we made in AWS and specify the "file path"
    host        = self.public_ip         //this command uses the ec2 instances public ip that it receives upon creation 
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
    
