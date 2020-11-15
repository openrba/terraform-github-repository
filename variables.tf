# Input Variables
variable "github_token" {
  description = "GitHub token used to create repos"
  type        = string
}

variable "github_org" {
  description = "GitHub Orginisation"
  type        = string
}

# Generated run.py
variable "azure_workspaces" {
  description = "map of workspace names to subscription information"
  type        = map
}