provider "google" {
  credentials = file("/var/jenkins_home/workspace/terrafrom_main/key.json")
  project     = "terrafrom1"
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
  zone         = "us-central1-b"

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }

service_account {
  scopes = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/devstorage.read_write"
  ]
}


  tags = ["web", "prod"]
}
