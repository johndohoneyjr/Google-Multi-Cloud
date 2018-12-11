provider "google" {
 project     = "john-dohoney-test-219619"
 region      = "us-central1"
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 8
}

//
// You will need to enable the IAM API to use this
// https://console.developers.google.com/apis/api/iam.googleapis.com
//
resource "google_service_account" "myaccount" {
  account_id = "dohoney-gcp-demo"
  display_name = "dohoney-gcp-demo"
}

resource "google_service_account_key" "mykey" {
  service_account_id = "${google_service_account.myaccount.name}"
  public_key_type = "TYPE_X509_PEM_FILE"
}

//resource "google_project_iam_binding" "cloud-admin" {
//    role    =  "roles/compute.admin"
//     members = [
//         "serviceAccount:${google_service_account.myaccount.email}"
//     ]
// }

resource "google_compute_firewall" "default" {
 name    = "flask-rest-app-firewall"
 network = "default"

 allow {
   protocol = "tcp"
   ports    = [ "22", "5000", "8080" ]
 }
}

resource "google_compute_instance" "default" {
 name         = "flask-vm-${random_id.instance_id.hex}"
 machine_type = "f1-micro"
 zone         = "us-central1-c"
  metadata {
     sshkeys = "ubuntu:${base64decode(google_service_account_key.mykey.public_key)}"
//   sshKeys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
 }
 boot_disk {
   initialize_params {
     image = "debian-cloud/debian-9"
   }
 }

 metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip wget rsync; sudo pip install flask; sudo apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common -y ; cd /home/ubuntu; wget https://s3-us-west-2.amazonaws.com/jdohoney-se-demo/setUpDocker.sh ; sudo chmod 755 /home/ubuntu/setUpDocker.sh; sudo /home/ubuntu/setUpDocker.sh; wget https://s3-us-west-2.amazonaws.com/jdohoney-se-demo/myhello.py; sudo python /home/ubuntu/myhello.py" 

 network_interface {
   network = "default"

   access_config {
     // Gives the VM  external ip address
   }
 }

  provisioner "file" {
    connection {
      type    = "ssh"
      user    = "root"
      timeout = "20s"
      private_key = "${base64decode(google_service_account_key.mykey.private_key)}"
//      private_key = "${file("~/.ssh/id_rsa")}"
    }

    source      = "${file("${path.module}/scripts/setUpDocker.sh")}"
    destination = "/home/ubuntu"
    on_failure = "continue"
  }


  provisioner "file" {
    connection {
      type    = "ssh"
      user    = "ubuntu"
      timeout = "20s"
      private_key = "${base64decode(google_service_account_key.mykey.private_key)}"
//      private_key = "${file("~/.ssh/id_rsa")}"
    }

    source      = "${file("${path.module}/scripts/myhello.py")}"
    destination = "/home/ubuntu"
    on_failure  = "continue"
  }

  depends_on = ["google_compute_firewall.default","random_id.instance_id"]
}
