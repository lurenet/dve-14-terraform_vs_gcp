variable "creds" {
  description = "Credentials file for GCP"
  type        = string
  default     = "credentials/dve-14.json"
}

variable "project_id" {
  type        = string
}

variable "region" {
  type        = string
  default     = "europe-west1"
}

variable "zone" {
  type        = string
  default     = "europe-west1-b"
}

variable "machine_type" {
  type        = string
  default     = "e2-medium"
}

variable "labels" {
  description = "List of labels to attach to the VM instance."
  type        = map
}

variable "nexus" {
  type    = map
  default = {
    "address"  = "1.1.1.1:8123"
    "login"    = "admin"
    "password" = "admin"
  }
}

variable "artifact" {
  type    = map
  default = {
    "name"    = "boxfuse"
    "version" = "latest"
    "project_url"  = "https://github.com/lurenet/dve-14-terraform_vs_gcp.git"
    "project_name" = "dve-14-terraform_vs_gcp"
  }
}
