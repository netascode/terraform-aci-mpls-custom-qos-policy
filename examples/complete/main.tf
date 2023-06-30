module "aci_mpls_custom_qos_policy" {
  source  = "netascode/mpls-custom-qos-policy/aci"
  version = ">= 0.0.1"

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
