provider "google" {
  project = "my-terraform-project"
  credentials = file("gcp_terraform_service_account.json")
  region = "us-central1"
  zone = "us-central1-b"
}

resource "google_compute_instance" "my_virtual_machine" {
  name = "terraform-instance"
  machine_type = "f1-micro"
  zone = "us-central1-b"
  allow_stopping_for_update = true
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    # network = "default"
    network = google_compute_network.terraform-network.self_link
    subnetwork = google_compute_subnetwork.terraform-subnet.self_link
    # access_config = {
    #     //Ephemeral Public IP
    # }
  }
}

resource "google_compute_network" "terraform-network" {
  name = "terraform-network"
  auto_create_subnetworks = flase
}

resource "google_compute_subnetwork" "terraform-subnet" {
  name = "terraform-subnet"
  ip_cidr_range = "10.2.0.0/16"
  region = "us-central1"
  network = google_compute_network.terraform-network.id
}