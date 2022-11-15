
output "vm_project" {
  value = google_compute_instance.vm.project
}

output "vm_zone" {
  value = google_compute_instance.vm.zone
}

output "vm_name" {
  value = google_compute_instance.vm.name
}

output "vm_private_ip" {
  value = google_compute_instance.vm.network_interface[0].network_ip
}

output "vpc_name" {
  value = google_compute_network.vpc_network.name
}

output "vpc_id" {
  value = google_compute_network.vpc_network.id
}

output "vpc_self_link" {
  value = google_compute_network.vpc_network.self_link
}
