resource "google_compute_network" "vpc_network" {
  name                    = "${var.name}-network"
  project                 = var.project
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.name}-subnet"
  project       = var.project
  ip_cidr_range = "10.20.0.0/16"
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

# SSH
resource "google_compute_firewall" "allow_ssh" {
  name          = "${var.name}-allow-ssh-from-iap-tunnel"
  project       = var.project
  network       = google_compute_network.vpc_network.name
  target_tags   = ["allow-ssh"] // this targets our tagged VM
  source_ranges = ["35.235.240.0/20"]
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

# ICMP
resource "google_compute_firewall" "allow_icmp" {
  name          = "${var.name}-allow-icmp"
  project       = var.project
  network       = google_compute_network.vpc_network.name
  target_tags   = ["allow-icmp"] // this targets our tagged VM
  source_ranges = ["0.0.0.0/0"]
  priority      = 2000
  allow {
    protocol = "icmp"
  }
}

data "google_compute_image" "debian_image" {
  family  = "debian-11"
  project = "debian-cloud"
}

resource "google_compute_instance" "vm" {
  name         = "${var.name}-vm"
  project      = var.project
  machine_type = "e2-medium"
  zone         = "${var.region}-c"

  tags = ["foo", "bar", "allow-ssh", "allow-icmp"]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian_image.self_link
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.subnet.id
  }
}
