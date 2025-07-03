terraform {
  backend "gcs" {
    bucket = "terraform-victor-state"   # Remplace par ton vrai nom de bucket
    prefix = "terraform/state"
  }
}

provider "google" {
  project = "handy-woodland-464607-p1"
  region  = "europe-west1"
  zone    = "europe-west1-b"
}

variable "vm_names" {
  default = ["front", "back", "db"]
}

resource "google_compute_address" "static_ips" {
  count  = length(var.vm_names)
  name   = "ip-${var.vm_names[count.index]}"
  region = "europe-west1"
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
    access_config {
      nat_ip = google_compute_address.static_ips[count.index].address
    }
  }

  metadata = {
    ssh-keys = "jenkins:${file("${path.module}/jenkins_ansible_key.pub")}"
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y python3 python3-pip
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
