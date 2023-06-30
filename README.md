<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-mpls-custom-qos-policy/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-mpls-custom-qos-policy/actions/workflows/test.yml)

# Terraform ACI MPLS Custom QoS Module

Description

Location in GUI:
`Tenants` » `infra` >> Policies` » `Protocol` » `MPLS Custom QoS Policy`

## Examples

```hcl
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
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Custom MPLS QoS Policy name. | `string` | n/a | yes |
| <a name="input_alias"></a> [alias](#input\_alias) | Custom MPLS QoS Policy alias. | `string` | `""` | no |
| <a name="input_description"></a> [description](#input\_description) | Custom MPLS QoS Policy description. | `string` | `""` | no |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | Custom MPLS QoS Policy Ingress Rules | <pre>list(object({<br>    priority    = optional(string, "unspecified")<br>    exp_from    = string<br>    exp_to      = string<br>    dscp_target = optional(string, "unspecified")<br>    cos_target  = optional(string, "unspecified")<br>  }))</pre> | `[]` | no |
| <a name="input_egress_rules"></a> [egress\_rules](#input\_egress\_rules) | Custom MPLS QoS Policy Egress Rules | <pre>list(object({<br>    dscp_from  = string<br>    dscp_to    = string<br>    exp_target = optional(string, "unspecified")<br>    cos_target = optional(string, "unspecified")<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `qosMplsCustomPol` object. |
| <a name="output_name"></a> [name](#output\_name) | Custom MPLS QoS Policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.qosMplsCustomPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.qosMplsEgressRule](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.qosMplsIngressRule](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->