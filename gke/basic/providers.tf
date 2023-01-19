terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.27.0"
    }
  }

  required_version = ">= 0.14"
}


provider "google" {
  project = var.project_id
  region  = var.region
  zone    = "us-central1-c"
}