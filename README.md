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

<!-- BEGIN_TF_DOCS -->


<!-- END_TF_DOCS -->

---

### Resources
1. [GitOps for Terraform Minicamp](https://morethancertified.com/course/gitops-for-terraform-minicamp)
2. [Enabling Plugin Cache Directory](https://github.com/hashicorp/setup-terraform/issues/4#issuecomment-2392374262)
