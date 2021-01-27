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
  name        = "ris-azr-group-github-${var.repository_name}-read"
  description = "${var.repository_name} Read Access"
  privacy     = "closed"
}

resource "github_team" "workspace_write" {
  name        = "ris-azr-group-github-${var.repository_name}-write"
  description = "${var.repository_name} Write Access"
  privacy     = "closed"
}

resource "github_team" "approvers" {
  name        = "ris-azr-group-github-${var.repository_name}-approvers"
  description = "${var.repository_name} Merge Request Approvers"
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
resource "github_branch" "branch" {
  for_each = var.repository_branches

  repository = github_repository.workspace.name
  branch     = each.key
}

resource "github_branch_protection_v3" "protection" {
  for_each = toset([ for name, branch in var.repository_branches: name if branch.protected == true ])

  repository     = github_repository.workspace.name
  branch         = each.key
  enforce_admins = true

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    dismissal_teams                 = [github_team.approvers.id]
    required_approving_review_count = 1
  }

  restrictions {
    teams = [github_team.approvers.id]
  }
}

# Administration Team
resource "github_team_repository" "all_repos" {
  team_id    = var.github_admin
  repository = github_repository.workspace.name
  permission = "admin"
}