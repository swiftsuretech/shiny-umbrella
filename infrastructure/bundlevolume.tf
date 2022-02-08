resource "aws_volume_attachment" "bundle-vol" {
  device_name  = "/dev/xvdv"
  volume_id    = "vol-0642f4ff48f59b616"
  instance_id  = aws_instance.btsec-pov-bastion-instance.id
  skip_destroy = true
}
