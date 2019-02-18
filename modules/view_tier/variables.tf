variable "bucket_name" {
  default="sparta-three-tier-app-terraform"
}

variable "src_directory" {
  description = "where to find the files"
}

variable "name" {
  default = "name"
}

variable "app_ip" {
  description = "NodeApp ip"
}
