resource "aws_s3_bucket" "terraform_state" {
  bucket = var.terraform_state_bucket


  tags = merge(local.common_tags, {
    Name        = "Terraform State Bucket"
    Description = "Central S3 bucket for storing Terraform state files"
  })
}
