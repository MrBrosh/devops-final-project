provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0453ec754f44f9a4a" # Ubuntu 24.04 LTS
  instance_type = "t2.micro"

  tags = {
    Name = "Web-Server-Final-Project"
  }
}