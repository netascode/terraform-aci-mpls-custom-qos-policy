resource "aci_rest_managed" "qosMplsCustomPol" {
  dn         = "uni/tn-infra/qosmplscustom-${var.name}"
  class_name = "qosMplsCustomPol"
  content = {
    name      = var.name
    nameAlias = var.alias
    descr     = var.description
  }
}

resource "aci_rest_managed" "qosMplsIngressRule" {
  for_each   = { for ir in var.ingress_rules : "${ir.exp_from}-${ir.exp_to}" => ir }
  dn         = "${aci_rest_managed.qosMplsCustomPol.dn}/exp-${each.value.exp_from}-${each.value.exp_to}"
  class_name = "qosMplsIngressRule"
  content = {
    from      = each.value.exp_from
    prio      = each.value.priority
    target    = each.value.dscp_target
    targetCos = each.value.cos_target
    to        = each.value.exp_to
  }
}

resource "aci_rest_managed" "qosMplsEgressRule" {
  for_each   = { for er in var.egress_rules : "${er.dscp_from}-${er.dscp_to}" => er }
  dn         = "${aci_rest_managed.qosMplsCustomPol.dn}/dscpToExp-${each.value.dscp_from}-${each.value.dscp_to}"
  class_name = "qosMplsEgressRule"
  content = {
    from      = each.value.dscp_from
    targetExp = each.value.exp_target
    targetCos = each.value.cos_target
    to        = each.value.dscp_to
  }
}