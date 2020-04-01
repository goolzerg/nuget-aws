provider "aws" {
  access_key = "YOUR_ACCESS_KEY"
  secret_key = "YOU_SECRET_KEY"
  region     = "us-east-1"
}

#EC2 Instance

resource "aws_instance" "nuget_repository" {
  ami             = "ami-0fc61db8544a617ed"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.allow_http_ssh.name}"]
  key_name        = aws_key_pair.key_pair_ssh.key_name
  user_data       = file("./data.txt")
}


#Security Group

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "allow_http_ssh" {
  name   = "allow_http_ssh3"
  vpc_id = aws_default_vpc.default.id

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
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

#SSH key

resource "aws_key_pair" "key_pair_ssh" {
  key_name   = "key_pair_ssh"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAhBaaEkzlUJ25LNjHxvZdT1wfGMwdLn2KJu+O4bb17YIIlqcImRsapsqW76fKr6pnu2eBmVxGfYDrdWEwEWqWMFQvFfrAfbMKNET8Dht8oJZqCdRm7kO+O3422rNA84/2FYiCEJWgUiUOYEa2D5zCHn9KL61yn3freSlAzE1bcMcm22WH9kMNRTpdCxQhJJF3YdZ9wJCIGsmHVoboDnUj38YGzYeFKmTOT1wRveZBA6WZ8vmHss2Domn/aHln2IpbYllWaoA2MrhVrRcdjznlR3bihRvV6/emVq2KkPQrCXoaMhy7lcGbNh1ismaYrNadZ0czYEx/FuZj4UgwZgD13w== rsa-key-20200401"
}

#Elastic IP address

resource "aws_eip" "nuget_repository" {
  instance = aws_instance.nuget_repository.id
  vpc      = true
}


output "public_ip" {
  value = aws_eip.nuget_repository.public_ip
}
