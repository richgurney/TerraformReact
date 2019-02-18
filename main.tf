provider "aws" {
  region  = "eu-west-2"
}

# create a vpc
resource "aws_vpc" "app" {
  cidr_block = "${var.cidr_block}"

  tags {
    Name = "${var.name}"
  }
}

# internet gateway
resource "aws_internet_gateway" "app" {
  vpc_id = "${aws_vpc.app.id}"

  tags {
    Name = "${var.name}"
  }
}

module "view" {
  source =  "./modules/view_tier"
  name = "Sparta-web"
  src_directory="presentation/build/static"
  app_ip="${module.app.app_instance}"
}

module "app" {
  source = "./modules/app_tier"
  vpc_id = "${aws_vpc.app.id}"
  name = "Sparta-app"
  user_data = "${data.template_file.app_init.rendered}"
  ig_id = "${aws_internet_gateway.app.id}"
  ami_id = "${var.app_ami_id}"
}

module "db" {
  source = "./modules/db_tier"
  vpc_id = "${aws_vpc.app.id}"
  name = "Sparta-db"
  ami_id = "${var.db_ami_id}"
  app_sg = "${module.app.security_group_id}"
  app_subnet_cidr = "${module.app.subnet_cidr_block}"
}

### load_balancers
resource "aws_security_group" "elb"  {
  name = "${var.name}-elb"
  description = "Allow all inbound traffic through port 80 and 443."
  vpc_id = "${aws_vpc.app.id}"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags {
    Name = "${var.name}-elb"
  }
}


resource "aws_lb" "SpartaLB" {
  name               = "${var.name}-app-elb"
  internal           = false
  load_balancer_type = "network"
  subnets = ["${module.app.subnet_app_id}"]
  enable_deletion_protection = false

  tags {
    Name = "SpartaLB"
  }
}

resource "aws_lb_target_group" "SpartaAppTG" {
  name     = "SpartaAppTG"
  port     = 80
  protocol = "TCP"
  vpc_id   = "${aws_vpc.app.id}"
}

resource "aws_lb_listener" "SpartaAppL" {
  load_balancer_arn = "${aws_lb.SpartaLB.arn}"
  port = 80
  protocol = "TCP"

  default_action {
    type = "forward"
    target_group_arn = "${aws_lb_target_group.SpartaAppTG.arn}"
  }
}

resource "aws_launch_configuration" "SpartaLaunchConfig" {
  name_prefix   = "${var.name}-app"
  image_id      = "${var.app_ami_id}"
  instance_type = "t2.micro"
  user_data = "${data.template_file.app_init.rendered}"
  security_groups = ["${module.app.security_group_id}"]
}

resource "aws_autoscaling_group" "SpartaAppAutoScaling" {
  name = "SpartaAppAutoScaling"
  availability_zones = ["eu-west-2a"]
  vpc_zone_identifier = ["${module.app.subnet_app_id}"]
  desired_capacity = 0
  max_size = 0
  min_size = 0
  launch_configuration = "${aws_launch_configuration.SpartaLaunchConfig.name}"
  target_group_arns = ["${aws_lb_target_group.SpartaAppTG.arn}"]
  tags {
    key = "Sparta"
    value = "App-AS"
    propagate_at_launch = true
  }
}

# Route 53
resource "aws_route53_record" "www" {
  zone_id = "${var.zone_id}"
  name    = "Sparta"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_lb.SpartaLB.dns_name}"]
}


# load the init template
data "template_file" "app_init" {
   template = "${file("./scripts/app/init.sh.tpl")}"
   vars {
      db_host="mongodb://${module.db.db_instance}:27017/posts"
   }
}
