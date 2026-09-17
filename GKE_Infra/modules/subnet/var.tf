variable "project_id" {
    type = string

}

variable "subnets" {
    type = map(object({
        region = string
        ip_cidr = string
        private_ip_google_access = optional(bool, true)

        secondary_ranges         = optional(list(object({
      range_name    = string
      ip_cidr_range = string
    })), [])
    }))
}

variable "vpc_name" { type = string }
