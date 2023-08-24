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

provider "google" {
  credentials = file("<YOUR-GCP-JSON-KEY-PATH>")
  project     = "<YOUR-GCP-PROJECT-ID>"
  region      = "us-central1"
}

// Generate an SSH key
resource "tls_private_key" "example" {
  algorithm = "RSA"
}

// Create multiple GCP instances without public IP and with the generated SSH key
resource "google_compute_instance" "default" {
  count        = 3 // Change this to however many instances you want
  name         = "vm-instance-${count.index}"
  machine_type = "f1-micro"
  zone         = "us-central1-a"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = "default"

    // This makes sure no public IP is assigned
    access_config {
      // empty block
    }
  }

  metadata = {
    ssh-keys = "terraform:${tls_private_key.example.public_key_openssh}"
  }
}

// Output the private and public keys
output "private_key" {
  value = tls_private_key.example.private_key_pem
  sensitive = true
}

output "public_key" {
  value = tls_private_key.example.public_key_openssh
}


service_account {
  scopes = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/devstorage.read_write"
  ]
}


  tags = ["web", "prod"]
}
