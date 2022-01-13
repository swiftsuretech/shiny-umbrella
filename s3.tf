resource "aws_s3_bucket_object" "bundle" {
  bucket = var.bucket_name
  key    = var.bundle_name
}
