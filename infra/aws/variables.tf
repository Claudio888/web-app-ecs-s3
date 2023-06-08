variable "zone_name" {
  type    = string
  default = "craudio"
}

variable "domain_name" {
  type    = string
  default = "craudio.com.br"
}

variable "environment_name" {
  type    = string
  default = "prod"
}

variable "record_name" {
  type    = string
  default = "prod"
}

variable "criar_dns" {
  type    = bool
  default = true
}
