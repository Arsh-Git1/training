resource "aws_db_instance" "default" {
  ...
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket" "static_files" {
  ...
  lifecycle {
    ignore_changes = [tags]
  }
}

