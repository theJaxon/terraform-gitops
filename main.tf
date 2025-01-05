terraform {
  backend "s3" {}
}

data "aws_ami" "ubuntu_ami" {
  most_recent = true
  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

resource "aws_instance" "ubuntu_instance" {
  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = "t3.micro"

  tags = {
    Name = "ubuntu"
  }
}