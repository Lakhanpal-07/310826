

variable "resource_group_name" {

  type = map(object({
    name     = string
    location = string
  }))
}
resource "azurerm_resource_group" "rg" {
  for_each = var.resource_group_name

  name     = each.value.name
  location = each.value.location
}
