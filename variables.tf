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
