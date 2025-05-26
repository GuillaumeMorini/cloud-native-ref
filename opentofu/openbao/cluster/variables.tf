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


variable "env" {
  description = "The environment of the OpenBao cluster"
  type        = string
}

variable "domain_name" {
  description = "The domain name for which the certificate should be issued"
  type        = string
}

variable "mode" {
  description = "OpenBao cluster mode (default dev, meaning a single node)"
  type        = string
  default     = "dev"

  validation {
    condition     = var.mode == "dev" || var.mode == "ha"
    error_message = "The mode must be 'dev' (1 node) or 'ha' (5 nodes)."
  }
}

variable "openbao_version" {
  description = "OpenBao version to install"
  type        = string
  default     = "2.2.1"
}

variable "openbao_data_path" {
  description = "Directory where OpenBao's data will be stored in an EC2 instance"
  type        = string
  default     = "/opt/openbao/data"
}

variable "name" {
  description = "Name of the resources created for this OpenBao cluster"
  default     = "openbao"
  type        = string
}

variable "leader_tls_servername" {
  type        = string
  description = "One of the shared DNS SAN used to create the certs use for mTLS"
}

variable "openbao_certificates_secret_name" {
  description = "The name of the GCP Secret Manager secret containing the OpenBao certificates"
  type        = string
}

variable "enable_ssm" {
  description = "If true, allow to connect to the instances using AWS Systems Manager"
  type        = bool
  default     = false
}

variable "prometheus_node_exporter_enabled" {
  description = "If set to true install and start a prometheus node exporter"
  type        = bool
  default     = false
}

