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

  name        = "MPLS_QOS_POL"
  alias       = "MPLS_QOS_POL-alias"
  description = "My Description"
  ingress_rules = [
    {
      priority    = "level1"
      exp_from    = "1"
      exp_to      = "2"
      dscp_target = "AF11"
      cos_target  = "0"
    }
  ]
  egress_rules = [
    {
      dscp_from  = "AF11"
      dscp_to    = "AF12"
      exp_target = "0"
      cos_target = "0"
    }
  ]
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

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.qosMplsCustomPol.content.descr
    want        = "My Description"
  }

  equal "nameAlias" {
    description = "nameAlias"
    got         = data.aci_rest_managed.qosMplsCustomPol.content.nameAlias
    want        = "MPLS_QOS_POL-alias"
  }
}

data "aci_rest_managed" "qosMplsIngressRule" {
  dn         = "${data.aci_rest_managed.qosMplsCustomPol.id}/exp-1-2"
  depends_on = [module.main]
}

resource "test_assertions" "qosMplsIngressRule" {
  component = "qosMplsIngressRule"

  equal "from" {
    description = "from"
    got         = data.aci_rest_managed.qosMplsIngressRule.content.from
    want        = "1"
  }

  equal "to" {
    description = "to"
    got         = data.aci_rest_managed.qosMplsIngressRule.content.to
    want        = "2"
  }

  equal "target" {
    description = "target"
    got         = data.aci_rest_managed.qosMplsIngressRule.content.target
    want        = "AF11"
  }

  equal "targetCos" {
    description = "targetCos"
    got         = data.aci_rest_managed.qosMplsIngressRule.content.targetCos
    want        = "0"
  }

  equal "prio" {
    description = "prio"
    got         = data.aci_rest_managed.qosMplsIngressRule.content.prio
    want        = "level1"
  }
}


data "aci_rest_managed" "qosMplsEgressRule" {
  dn         = "${data.aci_rest_managed.qosMplsCustomPol.id}/dscpToExp-AF11-AF12"
  depends_on = [module.main]
}


resource "test_assertions" "qosMplsEgressRule" {
  component = "qosMplsEgressRule"

  equal "from" {
    description = "from"
    got         = data.aci_rest_managed.qosMplsEgressRule.content.from
    want        = "AF11"
  }

  equal "to" {
    description = "to"
    got         = data.aci_rest_managed.qosMplsEgressRule.content.to
    want        = "AF12"
  }

  equal "targetExp" {
    description = "targetExp"
    got         = data.aci_rest_managed.qosMplsEgressRule.content.targetExp
    want        = "0"
  }

  equal "targetCos" {
    description = "targetCos"
    got         = data.aci_rest_managed.qosMplsEgressRule.content.targetCos
    want        = "0"
  }
}