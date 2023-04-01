# Terraform-Projects

Here are some Terraform Best practices that I use when creating projects! 

1) Modularize your code: meaning breaking it down into different modules or TF files to make it easier to manage, maintain, and reuse. 

2) Use Version Control:  By Version Control I mean having a system in place to track the changes made to your infrastructures code over time (A must when working with a team)

3) Keep your TFSTATE separate: The TFSTATE contains sensitive information and should be kept separate from your code. Best to keep it in a remote backend like S3.

4) Terraform Plan before APPLYING: Always make sure to run a Terraform PLAN before applying! This allows you to see what changes are going to be made to your infrastructure
             ,and allows you to confirm that those changes are the ones you were expecting.

5) Tag. Your. Resources: Tags will help organize your resources for when they provisioned

6) Use Trusted Module Sources: Best to avoid using modules that are not from trusted sources so you do not run into a potential security risk.

7) Use a Remote State: This allows you to share your TFSTATE between team members and allows for multiple people to work on the same infrastucture.

8) Encrypt Sensitive Data: Make your data sensitive so that it is not written in plain text and is easily accessible.

9) Test Your Code: Write tests for your code to ensure that your infrastructure is wokring as expected. This will help reduce the amount of errors in the DEV process.
