# main.tf
module "connection" {
  source = "./modules/connection"
  cidr_block          = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  public_subnet_az    = "ap-northeast-2a"
  private_subnet_cidr = "10.0.2.0/24"
  private_subnet_az   = "ap-northeast-2b"
}

module "computation" {
  source             = "./modules/computation"
  master_ami         = "ami-05d2438ca66594916"  
  worker_ami         = "ami-05d2438ca66594916"  
  worker_count       = 2
  subnet_id          = module.connection.public_subnet_id
  security_group_id  = module.connection.security_group_id
  key_name           = "arsh-tk-sep2"
}

module "storage" {
  source           = "./modules/storage"
  bucket_name      = "arsh-ecom-bucket"  
  # file_paths       = ["/home/einfochips/Training-Assessment-Task/E-commerce/ecom-site/index.html", "/home/einfochips/Training-Assessment-Task/E-commerce/ecom-site/script.js"]
  # file_sources     = ["/home/einfochips/Training-Assessment-Task/E-commerce/ecom-site/styles.css", "/home/einfochips/Training-Assessment-Task/E-commerce/ecom-site/logo.png"]
}
