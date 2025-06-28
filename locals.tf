locals {
  aca_name       = format("%s-ca", var.resources_name_prefix)
  aca_env_name   = format("%s-cae", var.resources_name_prefix)
  acr_name       = replace(format("%scr", var.resources_name_prefix), "-", "")
  aks_name       = format("%s-aks", var.resources_name_prefix)
  keyvault_name  = format("%s-kv", var.resources_name_prefix)
  redis_aci_name = format("%s-redis-ci", var.resources_name_prefix)
  rg_name        = format("%s-rg", var.resources_name_prefix)
  sa_name        = replace(format("%ssa", var.resources_name_prefix), "-", "")
}
