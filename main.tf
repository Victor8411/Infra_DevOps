provider "google" {
  project = "handy-woodland-464607-p1"
  region  = "europe-west1"
  zone    = "europe-west1-b"
}

variable "vm_names" {
  default = ["front", "back", "db"]
}

resource "google_compute_instance" "vms" {
  count        = length(var.vm_names)
  name         = "vm-${var.vm_names[count.index]}"
  machine_type = "e2-micro"
  zone         = "europe-west1-b"

  tags = [var.vm_names[count.index]]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  # Ajout de la clé publique utilisée par Jenkins
  metadata = {
    ssh-keys = "admin:${file("${path.module}/jenkins_ansible_key.pub")}"
  }

  metadata_startup_script = <<-EOT
    sudo apt update
    sudo apt install -y python3 python3-pip
  EOT

  labels = {
    role = var.vm_names[count.index]
  }
}

output "vm_ips" {
  value = {
    for i, name in var.vm_names :
    name => google_compute_instance.vms[i].network_interface[0].access_config[0].nat_ip
  }
}
