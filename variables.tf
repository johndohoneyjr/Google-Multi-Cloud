variable "myprivate-key" {
  description = "My Private Key"
  default     = ""
}

variable "mypublic-key" {
  description = "My Public Key"
  default     = ""
}

variable "gcp_region" {
  description = "GCP region, e.g. us-east1"
  default = "us-west1"
}

variable "gcp_zone" {
  description = "GCP zone, e.g. us-east1-b (which must be in gcp_region)"
  default = "us-west1-b"
}

variable "gcp_project" {
  description = "GCP project name"
  default="dohoney-gcp-demo"
}

variable "gcp_credentials" {
  description = "GCP project credentials"
  default="/Users/johndohoneyjr/.ssh/terraform.json"
}

