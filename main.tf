provider "google" {
  project     = "primal-gear-436812-t0"
  region      = "us-central1"
}

resource "google_compute_instance" "vm_instance" {
  name         = "ansible"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  tags = ["http-server"]

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-stream-9"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "root:${file("/root/.ssh/id_rsa")}"
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    sudo yum update
    sudo yum install -y httpd
    sudo systemctl start httpd
  EOT
}

output "instance_ip" {
  value = google_compute_instance.vm_instance.network_interface.0.access_config.0.nat_ip
}
