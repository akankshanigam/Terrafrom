provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "example" {
  ami           = "ami-08a52ddb321b32a8c"
  instance_type = "t2.micro"

  tags = {
    Name = "example-instance"
  }
}
