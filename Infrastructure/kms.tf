resource "aws_kms_key" "default" {
  description             = "default key"
  deletion_window_in_days = 10
  key_usage = "ENCRYPT_DECRYPT"
  is_enabled = true

  tags = var.tags
}