# Create Repos
resource "github_repository" "workspace" {
  name         = "${var.repository_prefix}-${var.repository_name}"
  description  = var.repository_description
  visibility   = var.repository_visibility
  homepage_url = var.repository_homepage

  template {
    owner      = "LexisNexis-TFE"
    repository = "tfe-workspace-template"
  }

}

# Create GitHub Teams
resource "github_team" "workspace_read" {
  name        = "${var.github_team_prefix}-${var.repository_name}-read"
  description = "${var.repository_name} Read Access"
  privacy     = "closed"
}

resource "github_team" "workspace_write" {
  name        = "${var.github_team_prefix}-${var.repository_name}-write"
  description = "${var.repository_name} Write Access"
  privacy     = "closed"
}

resource "github_team" "approvers" {
  name        = "${var.github_team_prefix}-${var.repository_name}-approvers"
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

resource "github_team_repository" "team_approvers" {
  team_id    = github_team.approvers.id
  repository = github_repository.workspace.name
  permission = "push"
}

# Branches
resource "github_branch" "branch" {
  for_each = var.repository_branches

  repository = github_repository.workspace.name
  branch     = each.key
}

resource "github_branch_protection" "protection" {
  for_each = toset([for name, branch in var.repository_branches : name if branch.protected == "true"])

  repository_id  = github_repository.workspace.node_id
  pattern        = each.key
  enforce_admins = true

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    required_approving_review_count = 1
  }

  push_restrictions = [github_team.approvers.node_id]

}

# Administration Team
resource "github_team_repository" "all_repos" {
  team_id    = var.github_admin_team
  repository = github_repository.workspace.name
  permission = "admin"
}

# Support Team
resource "github_team_repository" "support_reader" {
  count = var.github_support_team == null ? 0 : 1

  team_id    = var.github_support_team
  repository = github_repository.workspace.name
  permission = "pull"
}

# Global Team
resource "github_team_repository" "global" {
  count = var.repository_visibility == "internal" ? 1 : 0

  team_id    = var.github_global_team
  repository = github_repository.workspace.name
  permission = "push"
}