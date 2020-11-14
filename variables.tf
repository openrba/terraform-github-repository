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
variable "azure_subscriptions" {
  description = "map of subscription names to subscription ids"
  type        = map
}