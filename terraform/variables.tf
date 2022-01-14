variable "aws_profile" {
  description = "AWS Profile"
  type        = string
  default     = "222638339470_Mesosphere-PowerUser"
  sensitive   = true
}

variable "bucket_name" {
  description = "Bucket with binaries"
  type        = string
  default     = "btsec-pov"
}

variable "bundle_name" {
  description = "The air gapped bundle tarball"
  default     = "konvoy_image_bundle_v2.1.1_linux_amd64.tar.gz"
}

variable "cluster_name" {
  description = "This is the name of our cluster"
  type        = string
  default     = "btsec-pov"
}

variable "key" {
  description = "Private key for SSH access"
  type        = string
  default     = "../keys/btsec_twin.pem"
}

variable "inventory" {
  description = "The ansible inventory file location"
  type        = string
  default     = "/home/centos/ansible/inventory.yaml"
}

variable "no-download" {
  description = "Set to true to prevent downloading airgapped bundle"
  type        = bool
  default     = false
}

variable "dkpversion" {
  description = "The version we wish to deploy"
  type        = string
  default     = "2.1.1"
}
