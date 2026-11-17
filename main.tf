provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "my_company_data" {
  bucket = "my-secret-company-files-2026"
}

# ثغرة متعمدة: جعل الملفات متاحة للعامة على الإنترنت!
resource "aws_s3_bucket_public_access_block" "bad_security" {
  bucket = aws_s3_bucket.my_company_data.id

  block_public_acls       = false
  block_public_policy     = false
}
