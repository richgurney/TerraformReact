output subnet_app_id {
  description = "The id of the subnet"
  value = "${aws_subnet.app.id}"
}

output subnet_cidr_block {
  description = "The cidr block of the subnet"
  value = "${aws_subnet.app.cidr_block}"
}

output security_group_id {
  description = "The id of the security group"
  value = "${aws_security_group.app.id}"
}

output app_instance {
  description = "The instance"
  value = "${aws_instance.app.public_ip}"
}
