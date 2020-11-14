# Create Repos
resource "github_repository" "subscriptions" {
  for_each = var.azure_subscriptions
  
  name         = "tfe-prod-${each.key}"
  description  = "Terraform Enterprise Production Workspace"
  visibility   = "private"
  homepage_url = "https://tfe.lnrisk.io"

  template {
    owner = "LexisNexis-TFE"
    repository = "tfe-workspace-template"
  }

}

# Create GitHub Teams
resource "github_team" "subscription_read" {
  for_each = var.azure_subscriptions

  name        = "tfe-prod-${each.key}-read"
  description = "${each.key} Read Access"
  privacy     = "closed"
}

resource "github_team" "subscription_write" {
  for_each = var.azure_subscriptions

  name        = "tfe-prod-${each.key}-write"
  description = "${each.key} Write Access"
  privacy     = "closed"
}

# Team Permissions
resource "github_team_repository" "team_read" {
  for_each = var.azure_subscriptions
  
  team_id    = github_team.subscription_read[each.key].id
  repository = github_repository.subscriptions[each.key].name
  permission = "pull"
}

resource "github_team_repository" "team_write" {
  for_each = var.azure_subscriptions

  team_id    = github_team.subscription_write[each.key].id
  repository = github_repository.subscriptions[each.key].name
  permission = "push"
}