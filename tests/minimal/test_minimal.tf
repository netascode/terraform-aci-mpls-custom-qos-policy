terraform {
  required_version = ">= 1.3.0"

  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "CiscoDevNet/aci"
      version = ">=2.0.0"
    }
  }
}

module "main" {
  source = "../.."

  name = "MPLS_QOS_POL"
}

data "aci_rest_managed" "qosMplsCustomPol" {
  dn = "uni/tn-infra/qosmplscustom-MPLS_QOS_POL"

  depends_on = [module.main]
}

resource "test_assertions" "qosMplsCustomPol" {
  component = "qosMplsCustomPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.qosMplsCustomPol.content.name
    want        = "MPLS_QOS_POL"
  }

  equal "nameAlias" {
    description = "nameAlias"
    got         = data.aci_rest_managed.qosMplsCustomPol.content.nameAlias
    want        = ""
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.qosMplsCustomPol.content.descr
    want        = ""
  }
}
