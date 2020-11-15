output "azure_workspaces" {
  description = "Subscription Map"
  value = {
    for workspace in keys(var.azure_workspaces):
        workspace => {
            tenant_id         = var.azure_workspaces[workspace].tenant_id
            subscription_id   = var.azure_workspaces[workspace].subscription_id
            github_org        = var.github_org
            github_identifier = github_repository.workspaces[workspace].full_name
        }
  }
}