# Aws github actions access

Aws role to authenticate with github actions. Can be used with the official [aws credentials action](https://github.com/aws-actions/configure-aws-credentials).

## Usage example

This example allows s3 access for the github actions role.

```hcl
// example terraform main.tf file

module "github_actions_access_role" {
  source = "git::ssh://git@github.com/janstuemmel/github-aws-oidc-auth?ref=0.3.0"

  // optional
  role_name = "GithubActionsAccessRole"
  role_desc  = "Optional GithubActionsAccessRole description" 
  role_tags = { foo = "some tag" }
 
  // required
  github_repos = [
    "janstuemmel/some-repo:ref:refs/heads/master",
    "janstuemmel/other-repo:*",
  ]
}

resource "aws_iam_policy" "github_policy" {
  name        = "GithubActionsAccessRolePolicy"
  description = "Allow github actions access"
  policy      = data.aws_iam_policy_document.github_role.json
}

resource "aws_iam_role_policy_attachment" "github_role_policy_attachment" {
  role       = module.github_actions_access_role.role_name
  policy_arn = aws_iam_policy.github_policy.arn
}

data "aws_iam_policy_document" "github_role" {
  statement {
    effect   = "Allow"
    actions  = ["s3:*"]
    resources = ["*"]
  }
}
```

```yaml
# example github actions workflow file

on:
  push:
    branches:
      - master

jobs:
  s3:
    runs-on: ubuntu-latest

    # set permissions for oidc token auth
    permissions:
      id-token: write
      contents: write
      
    steps:
      # configure auth, needs aws account id
      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          role-to-assume: arn:aws:iam::${{ secrets.AWS_ACCOUNT_ID }}:role/GithubActionsAccessRole
          aws-region: eu-central-1

      # run aws cli script
      - run: aws s3 ls
```

## Resources
* [Configure OpenID Connect for GithubActions](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services)