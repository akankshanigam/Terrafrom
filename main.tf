provider "aws" {
  region = "us-west-2" # You can change this to your preferred region
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0" # Example Amazon Linux 2 LTS AMI
  instance_type = "t2.micro"

  tags = {
    Name = "example-instance"
  }
}
