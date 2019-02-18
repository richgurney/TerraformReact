variable "vpc_id" {
  description = "the vpc to launch the resource to"
}

variable "name" {
  description = "The name of the user"
}

variable "user_data" {
  description = "the user data to provision the instance"
}

variable "ig_id" {
  description = "The internet gateway to attach to route table"
}


variable "ami_id" {
  description = "The app ami"
}
