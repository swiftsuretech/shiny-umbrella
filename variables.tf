variable "aws_profile" {
  description = "AWS Profile"
  type        = string
  default     = "222638339470_Mesosphere-PowerUser"
  sensitive   = true
}

variable "buckt_name" {
  description = "Bucket with binaries"
  type = string
  default = "btsec-pov"
}
