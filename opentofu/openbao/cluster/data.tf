
data "google_secret_manager_secret" "openbao_certificates" {
  secret_id = var.openbao_certificates_secret_name
}

data "google_secret_manager_secret_version" "openbao_certificates" {
  secret = data.google_secret_manager_secret.openbao_certificates.id
}

locals {
  openbao_certificates = jsondecode(data.google_secret_manager_secret_version.openbao_certificates.secret_data)
}
