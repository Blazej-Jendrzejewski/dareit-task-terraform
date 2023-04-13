terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.0"
    }
  }
}

provider "google" {
  credentials = jsondecode(var.gcp_credentials)
  project     = var.gcp_project_id
  region      = "us-central1"
}

resource "google_container_cluster" "primary" {
  name               = "myapp-cluster"
  location           = "us-central1-c"
  initial_node_count = 1

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
    username = null
    password = null
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    tags = ["myapp-node"]
  }
}

resource "google_compute_firewall" "default" {
  name    = "myapp-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["myapp-node"]
}
