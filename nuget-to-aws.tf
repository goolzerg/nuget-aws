
provider "aws" {
  access_key = "AKIARGL4AXZWTHSCF6EY"
  secret_key = "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"
  region     = "us-east-1"
}

#EC2 Instance

resource "aws_instance" "nuget_repository" {
  ami             = "ami-0fc61db8544a617ed"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.allow_http_ssh.name}"]
  key_name        = aws_key_pair.key_pair_ssh.key_name
}


#Security Group

resource "aws_default_vpc" "default" {
    tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "allow_http_ssh" {
  name   = "allow_http_ssh"
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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEA+j/eUFfOMq/vSn9wU0NFuMeeqCw8hzbABOcNka86oWXBb3XazEucjl18LqKxiuprvwZUUmmuIPbBR/o1V7sYsahd2kx52FNezWiUn+PfFjOq+CJFcDd1p7TNwIeK1TV6JqbY7NnOsJR53+79kE1MlNNa1vMm9D617g3cLF0Ypzeo64XJbjk1AQiuFbecB679CO2WrBN4cla8wO/r5iOsLCKHeU+jpBwXF4fXq6IK/y8YCaG6EmikkQLI580ifz/ajGITzV5swWCeP2WVk4gxn8HYZt9yDpqKCMlllUp5aAaJbiX7lp85txXkglnFh8aPCadrkyB7tnyrD02N+/KiGQ== rsa-key-20200322"
}

#Elastic IP address

resource "aws_eip" "nuget_repository" {
  instance = aws_instance.nuget_repository.id
  vpc      = true
}


output "public_ip" {
  value = aws_eip.nuget_repository.public_ip
}
