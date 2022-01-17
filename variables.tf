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
  default     = ["15e29108718111e59b3dad31954647e3c344a231"]
}

// required

variable "github_repos" {
  description = "Repo to trust. E.g. ['your-namespace/your-repo:*'] or ['your-namespace/your-repo:ref:refs/heads/master']"
  type        = set(string)
}
