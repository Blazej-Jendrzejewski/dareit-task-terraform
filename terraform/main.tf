provider "google" {
  credentials = jsondecode(var.gcp_credentials)
  project     = var.gcp_project_id
  region      = "us-central1"
}

resource "google_container_cluster" "primary" {
  name     = "dareit-challenge-cluster"
  location = "us-central1-a"

  remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "dareit-challenge-node-pool"
  location   = "us-central1-a"
  cluster    = google_container_cluster.primary.name

  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-small"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}
