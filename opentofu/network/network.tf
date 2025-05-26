#
# NETWORK
#
resource "google_compute_network" "default" {
  provider                = google
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  provider                 = google
  name                     = var.subnet_name
  ip_cidr_range            = var.subnet_iprange
  region                   = var.gcp_region
  network                  = google_compute_network.default.name
  private_ip_google_access = true
}


resource "google_compute_router" "router" {
  project = var.gcp_project_id
  name    = "nat-router"
  network = google_compute_network.default.name
  region  = var.gcp_region
}

module "cloud-nat" {
  source  = "terraform-google-modules/cloud-nat/google"
  version = "~> 5.0"

  project_id                         = var.gcp_project_id
  region                             =  var.gcp_region
  router                             = google_compute_router.router.name
  name                               = "nat-config"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
