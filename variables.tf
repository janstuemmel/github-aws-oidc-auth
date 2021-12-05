// optional

variable "role_name" {
  description = "Role name for github actions to assume"
  type        = string
  default     = "GithubActionsAccessRole"
}

variable "role_desc" {
  description = "Role description for github actions access"
  type        = string
  default     = "Role to access aws via github actions"
}

variable "role_tags" {
  description = "Tags for the role"
  type        = map(any)
  default     = {}
}

variable "thumbprint_list" {
  description = "Thumbprint list for oidc provider"
  type        = set(string)
  default     = ["a031c46782e6e6c662c2c87c76da9aa62ccabd8e"]
}

// required

variable "github_repos" {
  description = "Repo to trust. E.g. ['your-namespace/your-repo:*'] or ['your-namespace/your-repo:ref:refs/heads/master']"
  type        = set(string)
}
