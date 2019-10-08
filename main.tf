provider "google" {
  credentials = "${file("service-account.json")}" 
  project     = "gcp-script-terra"
  region      = "us-central1"
   zone         = "us-central1-c"
}
 
resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network       = "default"
    access_config {
    }
  }
}


resource "google_compute_network" "vpc_network" {
  name                    = "terraform-network"
  auto_create_subnetworks = "true"
}


#Este recurso intenta ser la fuente autorizada en todas las API habilitadas, 
#lo que a menudo genera conflictos cuando ciertas acciones habilitan otras API. 
#Si no necesita asegurarse de que esté habilitado exclusivamente un conjunto particular de API, 
#lo más probable es que use el recurso google_project_service, un recurso por API.
#Habilitar cloud resource manager  
resource "google_project_services" "my_project" {
  project = "gcp-script-terra"
  services   = ["iam.googleapis.com", "cloudresourcemanager.googleapis.com"]
}
