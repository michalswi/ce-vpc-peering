
provider "google" {}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "=4.43.0"
      # version = "~>4.0"
    }
  }
  # terraform version
  required_version = "~>1.2.0"
}
