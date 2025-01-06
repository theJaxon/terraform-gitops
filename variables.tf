variable "ec2_instance_type" {
  description = "Type of EC2 instance."
  default     = "t2.micro"
}

variable "grafana_port" {
  description = "Grafana port number."
  default     = 3000
}