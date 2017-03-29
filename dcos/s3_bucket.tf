resource "aws_s3_bucket" "exhibitor" {
  bucket = "cnry-exhibitor-${var.environment}"
  force_destroy = true

  lifecycle {
    prevent_destroy = false
  }
}
