variable "vpc_id" {
  description = "the vpc to launch the resource to"
}

variable "name" {
  description = "The name of the user"
}

variable "ami_id" {
  description = "The db ami"
}

variable "app_sg" {
  description = "sg for app"
}

variable "app_subnet_cidr" {
  description = "subnet for app"
}
