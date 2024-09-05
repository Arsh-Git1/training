# modules/storage/variables.tf
variable "bucket_name" {
  description = "Name of the S3 bucket."
  type        = string
}

# variable "file_paths" {
#   description = "List of file paths in the S3 bucket."
#   type        = list(string)
# }

# variable "file_sources" {
#   description = "List of local file paths to upload."
#   type        = list(string)
# }
