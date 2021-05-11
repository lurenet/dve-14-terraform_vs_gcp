data "google_compute_image" "ubuntu" {
  family  = "ubuntu-2004-lts"
  project = "ubuntu-os-cloud"
}

# Creates build inveronment
resource "google_compute_instance" "build" {
  name         = "build"
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["build-server"]
  labels       = var.labels

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
    }
  }

  network_interface {
    network = google_compute_network.dve14_network.name
    access_config {
      // Ephemeral IP
    }
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = self.network_interface[0].access_config[0].nat_ip
      user        = "root"
      timeout     = "500s"
      private_key = "${file("~/.ssh/id_rsa")}"
    }

    inline = [
      "apt update && apt install -y docker.io git",
      "echo \"{\\\"insecure-registries\\\":[\\\"${var.nexus["address"]}\\\"]}\" >> /etc/docker/daemon.json",
      "systemctl restart docker",
      "if [ ! -d \"/tmp/docker\" ]; then mkdir /tmp/docker; fi",
      "cd /tmp/docker",
      "if [ ! -d \"./${var.artifact["project_name"]}\" ]; then git clone ${var.artifact["project_url"]} && cd ./${var.artifact["project_name"]}/source; else cd ./${var.artifact["project_name"]} && git pull && cd ./source; fi",
      "docker image build -t ${var.nexus["address"]}/${var.artifact["name"]}:${var.artifact["version"]} .",
      "docker login -u ${var.nexus["login"]} -p ${var.nexus["password"]} ${var.nexus["address"]}",
      "docker push ${var.nexus["address"]}/${var.artifact["name"]}:${var.artifact["version"]}",
    ]
  }

  metadata = {
    ssh-keys = "root:${file("~/.ssh/id_rsa.pub")}"
  }
}

# Creates prod inveronment
resource "google_compute_instance" "prod" {
  name         = "prod"
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["prod-server"]
  labels       = var.labels

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
    }
  }

  network_interface {
    network = google_compute_network.dve14_network.name
    access_config {
      // Ephemeral IP
    }
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = self.network_interface[0].access_config[0].nat_ip
      user        = "root"
      timeout     = "500s"
      private_key = "${file("~/.ssh/id_rsa")}"
    }

    inline = [
      "apt update && apt install -y docker.io git",
      "echo \"{\\\"insecure-registries\\\":[\\\"${var.nexus["address"]}\\\"]}\" >> /etc/docker/daemon.json",
      "systemctl restart docker",
      "docker run -d -p 80:8080 ${var.nexus["address"]}/${var.artifact["name"]}:${var.artifact["version"]}",
    ]
  }

  metadata = {
    ssh-keys = "root:${file("~/.ssh/id_rsa.pub")}"
  }

  depends_on = [google_compute_instance.build]
}

