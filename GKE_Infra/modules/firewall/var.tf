variable "firewall_rules" {
    type = map(object({
        action = optional(string, "allow")
        direction = optional(string, "INGRESS")
        priority = optional(number, 1000)
        protocol = string
        port = optional(list(string))
        source_ranges = optional(list(string))
        source_tags = optional(list(string))
        source_service_accounts = optional(list(string))
        target_tags = optional(list(string))
        target_service_accounts = optional(list(string))
        project.id = string


    }))
}