variable "vnet_map" {
  type = map(object({
    name           = string
    location       = string
    resource_group = string
    address_space  = list(string)
  }))
}

resource "azurerm_virtual_network" "vnet" {
  for_each = var.vnet_map

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group
  address_space       = each.value.address_space
}
