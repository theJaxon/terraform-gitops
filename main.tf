terraform {
  backend "s3" {}
}

module "github-oidc-provider" {
  source                   = "github.com/theJaxon/terraform-aws-github-oidc-provider"
  github_organization_name = "theJaxon"
  github_repository_name   = "terraform-gitops"
}

module "s3backend" {
  source = "github.com/theJaxon/terraform-aws-s3-backend"
  principal_arn_list = [ module.github-oidc-provider.aws_iam_role_arn ]
}

data "aws_ami" "ubuntu_ami" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "grafana_instance" {
  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = var.ec2_instance_type

  tags = {
    Name        = "Ubuntu",
    Environment = "Dev",
    Service     = "Grafana"
  }
}

resource "aws_security_group" "grafana_sg" {
  name        = "grafana_sg"
  description = "Allow port 3000"
  # vpc_id      = aws_vpc.gitops_vpc.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Grafana-SG",
    Environment = "Dev",
    Service     = "Grafana"
  }
}

check "grafana_health_check" {
  data "http" "health_check" {
    url = "http://${aws_instance.grafana_instance.public_ip}:${var.grafana_port}"
    retry {
      attempts = 5
    }
  }
  assert {
    condition     = data.http.health_check.status_code == 200
    error_message = "Grafana is unreachable via port ${var.grafana_port}."
  }
}
