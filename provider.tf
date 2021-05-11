// Configure the Google Cloud provider
provider "google" {
  credentials = file("credentials/dve-14-457d9f49312b.json")
  project     = var.project_id
  region      = var.region
}
