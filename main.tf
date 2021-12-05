
data "aws_iam_policy_document" "github_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringLike"
      values   = [for repo in var.github_repos : "repo:${repo}"]
      variable = "token.actions.githubusercontent.com:sub"
    }
    
    principals {
      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.github_oidc.arn
      ]
    }
  }
}

resource "aws_iam_role" "github_role" {
  name               = var.role_name
  description        = var.role_desc
  assume_role_policy = data.aws_iam_policy_document.github_assume.json

  tags = var.role_tags
}

resource "aws_iam_openid_connect_provider" "github_oidc" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = var.thumbprint_list
}
