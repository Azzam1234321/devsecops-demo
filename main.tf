provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "my_company_data" {
  bucket = "my-secret-company-files-2026"
  
  
  # checkov:skip=CKV_AWS_144: "Cross-region replication is not required for this demo."
  # checkov:skip=CKV_AWS_18: "Access logging requires a separate log bucket."
  # checkov:skip=CKV2_AWS_62: "Event notifications (SQS/SNS) are not needed."
}


resource "aws_s3_bucket_public_access_block" "bad_security" {
  bucket                  = aws_s3_bucket.my_company_data.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true  
  restrict_public_buckets = true  
}


resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.my_company_data.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_kms_key" "mykey" {
  description         = "KMS key for S3 bucket encryption"
  enable_key_rotation = true
  
  # checkov:skip=CKV2_AWS_64: "KMS Policy is not required for this local demo environment."
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.my_company_data.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}


resource "aws_s3_bucket_lifecycle_configuration" "example" {
  bucket = aws_s3_bucket.my_company_data.id
  rule {
    id      = "archive-old-files"
    status  = "Enabled"
    
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}