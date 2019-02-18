output db_instance {
  description = "The instance"
  value = "${aws_instance.db.private_ip}"
}
