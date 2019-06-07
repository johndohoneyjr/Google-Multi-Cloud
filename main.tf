provider "google" {
 credentials = "${var.gcp_credentials}"
 project     = "${var.gcp_project}"
 region      = "${var.gcp_region}"
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 8
}

resource "google_compute_firewall" "default" {
 name    = "flask-rest-app-firewall"
 network = "default"

 allow {
   protocol = "tcp"
   ports    = [ "22", "5000", "8080" ]
 }
}

resource "google_compute_instance" "default" {
 name         = "nodeapi-vm-${random_id.instance_id.hex}"
 machine_type = "f1-micro"
 location         = "us-west1-b"
  metadata {
//   sshKeys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
     sshKeys = "ubuntu:${var.mypublic-key}"
 }
 boot_disk {
   initialize_params {
     image = "debian-cloud/debian-9"
   }
 }

 metadata_startup_script = "echo \"start-up complete\""

 network_interface {
   network = "default"

   access_config {
     // Gives the VM  external ip address
   }
 }

  provisioner "remote-exec" {
    connection {
      type    = "ssh"
      user    = "ubuntu"
      timeout = "20s"
//      private_key = "${file("~/.ssh/id_rsa")}"
      private_key =  "${var.myprivate-key}"
    }

    inline = [
      "sudo apt-get update",
      "sudo apt install apt-transport-https ca-certificates curl software-properties-common -y",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable\"",
      "sudo apt update",
      "apt-cache policy docker-ce",
      "sudo apt install docker-ce -y",
      "sudo docker run -d -p 8080:8080 johndohoney/simplenodeapi"
    ]
  }

//  provisioner "file" {
//    connection {
//      type    = "ssh"
//      user    = "ubuntu"
//      timeout = "20s"
//      private_key = "${file("~/.ssh/id_rsa")}"
//      private_key =  "${var.myprivate-key}"
//    }
//
//    source      = "${file("${path.module}/scripts/setUpDocker.sh")}"
//    destination = "/home/ubuntu/setUpDocker.sh"
//    on_failure = "continue"
//  }

  depends_on = ["google_compute_firewall.default","random_id.instance_id"]
}
