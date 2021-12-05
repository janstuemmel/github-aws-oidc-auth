# Aws github actions access

Aws role to authenticate with github actions. Can be used with the official [aws credentials action](https://github.com/aws-actions/configure-aws-credentials).

## Usage example

This example allows s3 access for the github actions role.

```hcl
module "github_actions_access_role" {
  source = "git::ssh://git@github.com/janstuemmel/github-aws-oidc-auth"

  // optional
  role_name = "GithubActionsAccessRole"
  role_dec  = "Optional GithubActionsAccessRole description" 
  role_tags = { foo = "some tag" }
 
  // required
  github_repos = [
    "janstuemmel/some-repo:ref:refs/heads/master"
    "janstuemmel/other-repo:*"
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
