# Create Repos
resource "github_repository" "workspaces" {
  for_each = var.azure_workspaces
  
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
resource "github_team" "workspace_read" {
  for_each = var.azure_workspaces

  name        = "ris-azr-group-tfe-${each.key}-read"
  description = "${each.key} Read Access"
  privacy     = "closed"
  ldap_dn     = "ris-azr-group-tfe-${each.key}-read"
}

resource "github_team" "workspace_write" {
  for_each = var.azure_workspaces

  name        = "ris-azr-group-tfe-${each.key}-write"
  description = "${each.key} Write Access"
  privacy     = "closed"
  ldap_dn     = "ris-azr-group-tfe-${each.key}-write"
}

# Team Permissions
resource "github_team_repository" "team_read" {
  for_each = var.azure_workspaces
  
  team_id    = github_team.workspace_read[each.key].id
  repository = github_repository.workspaces[each.key].name
  permission = "pull"
}

resource "github_team_repository" "team_write" {
  for_each = var.azure_workspaces

  team_id    = github_team.workspace_write[each.key].id
  repository = github_repository.workspaces[each.key].name
  permission = "push"
}

# Administration Team
resource "github_team" "admin" {
  name        = "ris-azr-group-tfe-administrators"
  description = "Terraform Enterprise Production Administrators"
  privacy     = "secret"
}

resource "github_team_repository" "all_repos" {
  for_each = var.azure_workspaces

  team_id    = github_team.admin.id
  repository = github_repository.workspaces[each.key].name
  permission = "admin"
}