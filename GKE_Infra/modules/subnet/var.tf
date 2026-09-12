variable "project.id" {
    type = "string"

}

variable "subnet" {
    type = map(object({
        region = string
        cidr = string
        private_ip_google_access = optional(bool, true)

        secondary_ranges         = optional(list(object({
      range_name    = string
      ip_cidr_range = string
    })), [])
    }))
}