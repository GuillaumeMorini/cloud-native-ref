locals {
  name = format("%s-%s-%s", var.gcp_region, var.env, var.name)
  tags = {
    "OpenBaoInstance" = local.name
  }
}
