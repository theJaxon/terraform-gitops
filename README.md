# terraform-gitops
Deploying Terraform AWS resources via Github actions.

### Bootstraping
```hcl
module "github-oidc-provider" {
  source                   = "github.com/theJaxon/terraform-aws-github-oidc-provider"
  github_organization_name = "theJaxon"
  github_repository_name   = "terraform-gitops"
}

module "s3backend" {
  source = "github.com/theJaxon/terraform-aws-s3-backend"
  principal_arn_list = [ module.github-oidc-provider.aws_iam_role_arn ]
}
```

```bash
export AWS_PROFILE=""
terraform init -migrate-state

# Provider caching
# Updates .terraform.lock.hcl
terraform providers lock -platform=darwin_arm64 -platform=linux_amd64
```

---

### Resources
1. [GitOps for Terraform Minicamp](https://morethancertified.com/course/gitops-for-terraform-minicamp)
2. [Enabling Plugin Cache Directory](https://github.com/hashicorp/setup-terraform/issues/4#issuecomment-2392374262)
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_http"></a> [http](#requirement\_http) | 3.4.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.82.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_github-oidc-provider"></a> [github-oidc-provider](#module\_github-oidc-provider) | github.com/theJaxon/terraform-aws-github-oidc-provider | n/a |
| <a name="module_s3backend"></a> [s3backend](#module\_s3backend) | github.com/theJaxon/terraform-aws-s3-backend | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_instance.grafana_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_security_group.grafana_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ami.ubuntu_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ec2_instance_type"></a> [ec2\_instance\_type](#input\_ec2\_instance\_type) | Type of EC2 instance. | `string` | `"t2.micro"` | no |
| <a name="input_grafana_port"></a> [grafana\_port](#input\_grafana\_port) | Grafana port number. | `number` | `3000` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->