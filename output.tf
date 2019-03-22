// A variable for extracting the external ip of the instance
output "ip" {
 value = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
}

//output "Private-Key" {
//  value="${base64decode(google_service_account_key.mykey.private_key)}"
//}
