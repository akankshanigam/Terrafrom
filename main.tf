provider "google" {
  ccredentials = file("/var/jenkins_home/workspace/terrafrom_main/credentials.json")
  project     = "hadoop"
  region      = "us-central1"
}

variable "credentials_file" {
  description = "Path to the GCP credentials JSON file"
  type        = string
  default     = "/var/jenkins_home/workspace/terrafrom_main/credentials.json" // Default to the working directory
}

resource "google_compute_instance" "default" {
  name         = "example-instance"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }

  service_account {
    scopes = ["compute-ro", "view"]
  }

  tags = ["web", "prod"]
}
