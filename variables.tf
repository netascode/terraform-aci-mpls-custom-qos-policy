variable "name" {
  description = "Custom MPLS QoS Policy name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "alias" {
  description = "Custom MPLS QoS Policy alias."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.alias))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "Custom MPLS QoS Policy description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "ingress_rules" {
  description = "Custom MPLS QoS Policy Ingress Rules"
  type = list(object({
    priority    = optional(string, "unspecified")
    exp_from    = string
    exp_to      = string
    dscp_target = optional(string, "unspecified")
    cos_target  = optional(string, "unspecified")
  }))
  default = []

  validation {
    condition = alltrue([
      for ir in var.ingress_rules : try(ir.exp_from >= 0 && ir.exp_from <= 7, false)
    ])
    error_message = "`exp_from`: Allowed values are `unspecified` or a number between 0 and 7."
  }

  validation {
    condition = alltrue([
      for ir in var.ingress_rules : try(ir.exp_to >= 0 && ir.exp_to <= 7, false)
    ])
    error_message = "`exp_to`: Allowed values are `unspecified` or a number between 0 and 7."
  }

  validation {
    condition = alltrue([
      for ir in var.ingress_rules : ir.priority == null || try(contains(["unspecified", "level1", "level2", "level3", "level4", "level5", "level6", ], ir.priority), false)
    ])
    error_message = "`priority`: Allowed values are `unspecified`, `level1`, `level2`, `level3`, `level4`, `level5` or `level6`"
  }

  validation {
    condition = alltrue([
      for ir in var.ingress_rules : ir.dscp_target == null || try(contains(["unspecified", "CS0", "CS1", "AF11", "AF12", "AF13", "CS2", "AF21", "AF22", "AF23", "CS3", "AF31", "AF32", "AF33", "CS4", "AF41", "AF42", "AF43", "CS5", "VA", "EF", "CS6", "CS7"], ir.dscp_target), false) || try(tonumber(ir.dscp_target) >= 0 && tonumber(ir.dscp_target) <= 63, false)
    ])
    error_message = "`dscp_target`: Allowed values are `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7` or a number between 0 and 63."
  }

  validation {
    condition = alltrue([
      for ir in var.ingress_rules : ir.cos_target == "unspecified" || try(ir.cos_target >= 0 && ir.cos_target <= 7, false)
    ])
    error_message = "`cos_target`: Allowed values are `unspecified` or a number between 0 and 7."
  }
}

variable "egress_rules" {
  description = "Custom MPLS QoS Policy Egress Rules"
  type = list(object({
    dscp_from  = string
    dscp_to    = string
    exp_target = optional(string, "unspecified")
    cos_target = optional(string, "unspecified")
  }))
  default = []

  validation {
    condition = alltrue([
      for er in var.egress_rules : try(contains(["unspecified", "CS0", "CS1", "AF11", "AF12", "AF13", "CS2", "AF21", "AF22", "AF23", "CS3", "AF31", "AF32", "AF33", "CS4", "AF41", "AF42", "AF43", "CS5", "VA", "EF", "CS6", "CS7"], er.dscp_from), false) || try(tonumber(er.dscp_from) >= 0 && tonumber(er.dscp_from) <= 63, false)
    ])
    error_message = "`dscp_from`: Allowed values are `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7` or a number between 0 and 63."
  }

  validation {
    condition = alltrue([
      for er in var.egress_rules : try(contains(["unspecified", "CS0", "CS1", "AF11", "AF12", "AF13", "CS2", "AF21", "AF22", "AF23", "CS3", "AF31", "AF32", "AF33", "CS4", "AF41", "AF42", "AF43", "CS5", "VA", "EF", "CS6", "CS7"], er.dscp_to), false) || try(tonumber(er.dscp_to) >= 0 && tonumber(er.dscp_to) <= 63, false)
    ])
    error_message = "`dscp_to`: Allowed values are `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7` or a number between 0 and 63."
  }

  validation {
    condition = alltrue([
      for er in var.egress_rules : er.exp_target == "unspecified" || try(er.exp_target >= 0 && er.exp_target <= 7, false)
    ])
    error_message = "`exp_from`: Allowed values are `unspecified` or a number between 0 and 7."
  }

  validation {
    condition = alltrue([
      for er in var.egress_rules : er.cos_target == "unspecified" || try(er.cos_target >= 0 && er.cos_target <= 7, false)
    ])
    error_message = "`cos_target`: Allowed values are `unspecified` or a number between 0 and 7."
  }
}
