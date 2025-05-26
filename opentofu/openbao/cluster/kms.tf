resource "google_kms_key_ring" "openbao" {
  name     = "openbao-kms"
  location = "global"
  project  = var.gcp_project_id
}

resource "google_kms_crypto_key" "openbao-key" {
  name            = "openbao-key"
  key_ring        = google_kms_key_ring.openbao.id
  rotation_period = "7776000s"

  lifecycle {
    prevent_destroy = true
  }
}