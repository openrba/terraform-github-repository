output "azure_workspaces" {
  description = "Subscription Map"
  value = {
    for workspace in keys(var.repository_branches) :
    workspace => {
      tenant_id                = var.repository_branches[workspace].tenant_id
      subscription_id          = var.repository_branches[workspace].subscription_id
      cloud_name               = var.repository_branches[workspace].cloud_name
      github_org               = var.github_org
      github_identifier        = github_repository.workspace.full_name
      additional_subscriptions = var.repository_branches[workspace].additional_subscriptions
    }
  }
}