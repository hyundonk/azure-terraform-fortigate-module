
variable "custom_data" {
  default = null
}

variable "load_balancer_param" {
  description = "load balancer parameters"
  type = object({
    sku             = string
    probe_protocol  = string
    probe_port      = number
    probe_interval  = number
    probe_num       = number
  })
  default = {
      sku             = "basic"
      probe_protocol  = "Tcp"
      probe_port      = 22
      probe_interval  = 5
      probe_num       = 2
  }
}

