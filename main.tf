# Create Repos
resource "github_repository" "workspace" {  
  name         = "tfe-prod-${var.repository_name}"
  description  = "Terraform Enterprise Production Workspace"
  visibility   = var.repository_visibility
  homepage_url = "https://tfe.lnrisk.io"

  template {
    owner = "LexisNexis-TFE"
    repository = "tfe-workspace-template"
  }

}

# Create GitHub Teams
resource "github_team" "workspace_read" {
  name        = "ris-azr-group-tfe-${var.repository_name}-read"
  description = "${var.repository_name} Read Access"
  privacy     = "closed"
}

resource "github_team" "workspace_write" {
  name        = "ris-azr-group-tfe-${var.repository_name}-write"
  description = "${var.repository_name} Write Access"
  privacy     = "closed"
}

# Team Permissions
resource "github_team_repository" "team_read" { 
  team_id    = github_team.workspace_read.id
  repository = github_repository.workspace.name
  permission = "pull"
}

resource "github_team_repository" "team_write" {
  team_id    = github_team.workspace_write.id
  repository = github_repository.workspace.name
  permission = "push"
}

# Branches
resource "github_branch" "development" {
  for_each = var.repository_branches

  repository = github_repository.workspace.name
  branch     = each.key
}

# Administration Team
resource "github_team_repository" "all_repos" {
  team_id    = var.github_admin
  repository = github_repository.workspace.name
  permission = "admin"
}