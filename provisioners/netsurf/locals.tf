locals {
  name        = "netsurf"
  prefix      = "pipelines"
  code_source = "https://github.com/mr-chelyshkin/NetSurf.git"
  tags = {
    "definition" : local.prefix
    "source" : local.code_source
    "project" : local.name
  }
}