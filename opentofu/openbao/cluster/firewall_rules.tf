resource "google_compute_firewall" "openbao" {
  name    = "allow-openbao"
  network = var.network_name

  allow {
    protocol = "tcp"
    ports    = ["8200-8201"]
  }

  target_tags = ["openbao"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "ssh" {
  name    = "allow-ssh"
  network = var.network_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }


  target_tags = ["ssh"]
  source_ranges = ["0.0.0.0/0"]

}
resource "google_compute_firewall" "prom-exporter" {
  name    = "allow-prom-exporter"
  network = var.network_name

  allow {
    protocol = "tcp"
    ports    = ["9100"]
  }

  source_tags = ["prom"]
  target_tags = ["prom-exporter"]
}