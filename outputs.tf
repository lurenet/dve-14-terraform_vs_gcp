output "tomcat_server_ip" {
  value = google_compute_instance.prod.network_interface.0.access_config.0.nat_ip
}
