variable "gcp_project_id" {
  type = string
}

variable "gcp_region" {
  type = string
}

variable "gcp_zone" {
  type = string
}

variable "network_name" {
  description = "The name of the Cloud Workstation cluster network"
  type        = string
  default     = "cn-network"
}

variable "subnet_name" {
  description = "The name of the Cloud Workstation cluster subnet"
  type        = string
  default     = "cn-subnet"
}

variable "subnet_iprange" {
  description = "The IP range of the Cloud Workstation cluster subnet"
  type        = string
  default     = "10.0.0.0/16"
}
