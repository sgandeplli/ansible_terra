provider "google" {
  project     = "primal-gear-436812-t0"
  region      = "us-central1"
}

resource "google_compute_instance" "vm_instance" {
  name         = "web-server-instance"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  tags = ["http-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "root:${file("/root/.ssh/id_rsa.pub")}"
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y apache2
    sudo systemctl start apache2
  EOT
}

output "instance_ip" {
  value = google_compute_instance.vm_instance.network_interface.0.access_config.0.nat_ip
}
