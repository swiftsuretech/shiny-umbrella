resource "aws_volume_attachment" "bundle-vol" {
  device_name  = "/dev/xvdv"
  volume_id    = "vol-0d6f579a34572bef2"
  instance_id  = aws_instance.btsec-pov-bastion-instance.id
  skip_destroy = true
}
