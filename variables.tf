# Input Variable
variable "repository_name" {
  description = "GitHub Respository Name"
  type        = string
}

variable "repository_branches" {
  description = "GitHub Branches"
  type        = map
}

variable "repository_visibility" {
  description = "GitHub Repository Visibility"
  type        = string
}

variable "github_admin" {
  description = "GitHub Admin Team ID"
  type        = string
}

variable "github_org" { 
  description = "GitHub Orginisation"
  type        = string
}