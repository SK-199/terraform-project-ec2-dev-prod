provider "aws" {
  region = var.region
}

resource "aws_instance" "app" {
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name = var.instance_name
  }
}
