provider "aws" {
  region = "us-west-1"  # Change this to your desired AWS region
}

resource "aws_instance" "example_instance" {
  ami           = "ami-0c55b159cbfafe1f0"  # Specify the AMI ID for your desired instance type and region
  instance_type = "t2.micro"
  key_name      = "your_key_pair_name"  # Replace with the name of your EC2 key pair
}

output "instance_ip" {
  value = aws_instance.example_instance.public_ip
}
