terraform {
  backend "s3" {
    bucket = "bucket_placeholder"
    key = "key_placeholder"
    region = "region_placeholder"
    encrypt = "true"
  }
}