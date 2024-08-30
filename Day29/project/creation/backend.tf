terraform {
  backend "s3" {
    bucket         = "arsh-terraform-bucket" 
    key            = "terraform/state.tfstate"
    region         = "ap-south-1" 
    encrypt        = true
    dynamodb_table = "arsh-locks" 
  }
}
