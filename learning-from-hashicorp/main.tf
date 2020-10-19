
provider "google" {

  credentials = var.credential_file

  project = var.project
  region = var.regions
  zone = var.zone
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

resource "google_compute_instance" "vm_instance" {
  name = "terraform-instance"
  machine_type = "f1-micro"
  tags = ["web", "dev"]

  boot_disk {
    initialize_params {
      image = "rhel-cloud/rhel-7"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.self_link
    access_config {
      nat_ip = google_compute_address.vm_static_ip.address
    }
  }
}

resource "google_compute_instance" "vm_instance-2" {
  name = "terraform-instance-2"
  machine_type = "f1-micro"
  tags = ["web", "dev"]

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }

  provisioner "local-exec" {
    command = "echo ${google_compute_instance.vm_instance-2.name} >> text.txt"
  }
}


resource "google_compute_address" "vm_static_ip" {
  name = "terraform-static-ip"
}
