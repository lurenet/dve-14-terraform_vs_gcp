# Create a GCP network
resource "google_compute_network" "dve14_network" {
  name = "dve14-network"
}

# Create a GCP Firewall
resource "google_compute_firewall" "allow-all" {
  name    = "dve14-allow-all"
  network = google_compute_network.dve14_network.name

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
}
