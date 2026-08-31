variable "rg_map" {
  type = map(object({
    name     = string
    location = string
  }))
}
