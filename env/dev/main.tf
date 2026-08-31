

module "resource_group" {
  source = "../../modules/az-rg"
  resource_group_name = var.rg_map
}