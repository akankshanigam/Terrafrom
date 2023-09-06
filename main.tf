provider "google" {
  credentials = file("/Users/dilipnigam/Downloads/key.json")
  project     = "terrafrom1"
  region      = "us-central1"
}

resource "google_compute_instance" "jenkins" {
  name         = "jenkins-instance"
  machine_type = "n1-standard-2"
  zone         = "us-central1-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = "default"
    // No access_config block means no external IP
  }

  metadata = {
    ssh-keys = "YOUR_SSH_USERNAME:${file("~/.ssh/id_rsa.pub")}"
  }

  tags = ["jenkins", "web"]

  service_account {
    scopes = [
      "userinfo-email",
      "compute-ro",
      "storage-ro",
    ]
  }
}

resource "google_compute_firewall" "jenkins" {
  name    = "jenkins-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["jenkins"]
}
