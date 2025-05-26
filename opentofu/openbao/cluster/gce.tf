resource "google_service_account" "cn-sa" {
  account_id   = "cloudnative-sa"
  display_name = "Cloud Native Service Account"
}

resource "google_project_iam_member" "cn-iam" {
  project   = var.gcp_project_id
  role      = "roles/logging.logWriter"
  member    = "serviceAccount:${google_service_account.cn-sa.email}"
}
# add role to read the keys
resource "google_project_iam_member" "cn-iam-kms" {
  project   = var.gcp_project_id
  role      = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member    = "serviceAccount:${google_service_account.cn-sa.email}"
}

resource "google_project_iam_member" "cn-iam-view" {
  project   = var.gcp_project_id
  role      = "roles/cloudkms.viewer"
  member    = "serviceAccount:${google_service_account.cn-sa.email}"
}

resource "google_project_iam_member" "cn-iam-secretmanager" {
  project   = var.gcp_project_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cn-sa.email}"
}



resource "google_compute_instance" "dev" {
  name         = "${local.name}-dev"
  machine_type = "n2-standard-2"
  zone         = var.gcp_zone

  # Allow to recreate the instance if needed
  allow_stopping_for_update = true

  tags = ["openbao", "ssh", "prom-exporter"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = var.network_name
    subnetwork = var.subnet_name

  }
  
  metadata_startup_script = "${file("scripts/startup_script.sh")}"
  metadata = {
    openbao_version = var.openbao_version
  }
  
  shielded_instance_config {
    enable_secure_boot = true
  }
  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.cn-sa.email
    scopes = ["cloud-platform"]
  }

}