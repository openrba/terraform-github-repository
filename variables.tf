# Input Variable
variable "repository_prefix" {
  description = "GitHub Repostiroy name prefix"
  default     = "tfe-prod"
  type        = string
}

variable "repository_name" {
  description = "GitHub Respository Name"
  type        = string
}

variable "repository_description" {
  description = "The description tag for each repository"
  default     = "Terraform Enterprise Production Workspace"
  type        = string
}

variable "repository_branches" {
  description = "GitHub Branches"
  type        = map(any)
}

variable "repository_visibility" {
  description = "GitHub Repository Visibility"
  type        = string
}

variable "repository_homepage" {
  description = "Homepage URL for the repository"
  default     = "https://tfe.lnrisk.io"
  type        = string
}

variable "github_admin_team" {
  description = "GitHub Admin Team ID"
  type        = string
}

variable "github_global_team" {
  description = "GitHub Global Team ID"
  type        = string
}

variable "github_support_team" {
  description = "GitHub Support Team ID"
  type        = string
}

variable "github_org" {
  description = "GitHub Orginisation"
  type        = string
}

variable "github_team_prefix" {
  description = "GitHub team naming prefix"
  type        = string
  default     = "ris-azr-group-github"
}