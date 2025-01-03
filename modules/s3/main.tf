resource "aws_s3_bucket" "main" {
  bucket = "api-data-bucket-${random_id.bucket_suffix.hex}"
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

output "bucket_name" {
  value = aws_s3_bucket.main.id
}
