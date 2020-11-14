output "azure_subscriptions" {
  description = "Subscription Map"
  value = {
    for subscription in keys(var.azure_subscriptions):
        subscription => {
            tenant_id         = var.azure_subscriptions[subscription].tenant_id
            subscription_id   = var.azure_subscriptions[subscription].subscription_id
            github_org        = var.github_org
            github_identifier = github_repository.subscriptions[subscription].full_name
        }
  }
}