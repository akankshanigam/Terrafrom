provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  owners = ["amazon"] # This owner ID corresponds to Amazon's
}

resource "aws_instance" "my_instance" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  key_name    = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  tags = {
    Name = "MyInstance"
  }
}

resource "aws_key_pair" "my_key" {
  key_name   = "my-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "my_sg" {
  name        = "my_sg"
  description = "Allow inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
