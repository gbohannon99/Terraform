Hi, This is one of the first projects that im going to be adding to my portfolio! The main purpose of these projects to get more expirence working with Terraform and other cloud providers, such as AWS! 

This project specificly works with deploying AWS resources such as VPCs, Subnets, EC2 Instances, and much more via the use of Terraform. 
The main goal of this project is to depoloy a nginx webserver inside of a EC2 instance.

The basic steps I used to sucessfully code this project were as follows:

1) Create a VPC
2) Create a Public Subnet
3) Create a Internet Gateway
4) Create a Route Table to connect the Internet Gateway to associate the subnet to the Internet Gatway
5) Create a security group to give us access to the EC2 Instance
6) Create a Key Pair via the AWS Console for the EC2 instance
7) Create a EC2 Instance.
    a. use a remote provisioner to install nginx

Here is the Diagram I used: 

![image](https://user-images.githubusercontent.com/120689107/221710280-e17c507d-6418-4337-b742-77a6272f6387.png)
