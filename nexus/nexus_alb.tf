resource "aws_s3_bucket" "nexus_alb_logs_bucket" {
  acl    = "${var.acl}"
  bucket = "${var.alb_logs_bucket}"
  count  = "${var.create_alb_logs_bucket}"
  lifecycle_rule {
    enabled = true
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = 60
      storage_class = "GLACIER"
    }

  }
  policy = "${data.aws_iam_policy_document.alb_logs_bucket_data.json}"
  region = "${var.aws_region}"
  versioning {
    enabled = true
  }

  tags {
    Application = "${var.application}"
    Environment = "${var.environment}"
    Name        = "${var.vpc_name}-${var.hostname}-alb-logs-bucket"
    Product     = "${var.product}"
  }
}

resource "aws_lb" "nexus_alb" {
  access_logs {
    bucket  = "${var.alb_logs_bucket}"
    enabled = true
    prefix  = "${var.vpc_name}-${var.hostname}-alb"
  }

  count                      = "${var.enable_nexus_alb}"

  depends_on                 = [
    "aws_s3_bucket.nexus_alb_logs_bucket",
  ]

  enable_deletion_protection = true
  idle_timeout               = "${var.alb_idle_timeout}"
  internal                   = false
  load_balancer_type         = "application"
  name                       = "${var.vpc_name}-${var.hostname}-alb"
  security_groups            = ["${aws_security_group.nexus_alb_security_group.id}"]
  subnets                    = ["${data.terraform_remote_state.networks.public_subnet_id}"]

  tags {
    Application = "${var.application}"
    Environment = "${var.environment}"
    Name        = "${var.vpc_name}-${var.hostname}-alb"
    Product     = "${var.product}"
  }
}

resource "aws_alb_listener" "alb_http_listener" {
  count             = "${var.enable_nexus_alb}"

  default_action {
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
    target_group_arn = ""
    type = "redirect"
  }

  load_balancer_arn = "${aws_lb.nexus_alb.arn}"
  port              = "80"
  protocol          = "HTTP"
}

resource "aws_alb_listener" "alb_https_listener" {
  certificate_arn = "${var.certificate_arn}"
  count           = "${var.enable_nexus_alb}"

  default_action {
    target_group_arn = "${aws_alb_target_group.nexus_alb_public_http.arn}"
    type             = "forward"
  }

  load_balancer_arn = "${aws_lb.nexus_alb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "${var.alb_ssl_policy}"
}

resource "aws_lb_listener_rule" "nexus_alb_docker_group_http" {
  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.nexus_alb_docker_group_http.arn}"
  }

  condition {
    host_header {
      values = ["dockerhub.*"]
    }
  }

  listener_arn = "${aws_alb_listener.alb_https_listener.arn}"
  priority     = 98
}

resource "aws_lb_listener_rule" "nexus_alb_docker_private_http" {
  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.nexus_alb_docker_group_http.arn}"
  }

  condition {
    host_header {
      values = ["azukdocker.*"]
    }
  }

  listener_arn = "${aws_alb_listener.alb_https_listener.arn}"
  priority     = 97
}

resource "aws_lb_listener_rule" "nexus_alb_azuk_docker_http" {
  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.nexus_alb_docker_private_http.arn}"

  }

  condition {
    host_header {
      values = ["docker.*"]
    }
  }

  listener_arn = "${aws_alb_listener.alb_https_listener.arn}"
  priority     = 96
}

resource "aws_alb_target_group" "nexus_alb_public_http" {
  count = "${var.enable_nexus_alb}"

  health_check {
    healthy_threshold   = "${var.healthy_threshold}"
    interval            = "${var.interval}"
    matcher             = "${var.matcher}"
    path                = "/"
    port                = "${var.nexus_alb_public_port}"
    protocol            = "HTTP"
    timeout             = "${var.timeout}"
    unhealthy_threshold = "${var.unhealthy_threshold}"
  }

  name     = "${var.vpc_name}-${var.hostname}-alb-http"
  port     = "${var.nexus_alb_public_port}"
  protocol = "HTTP"

  stickiness {
    type = "lb_cookie"
  }

  tags {
    Application = "${var.application}"
    Environment = "${var.environment}"
    Name        = "${var.vpc_name}-${var.hostname}-tg"
    Product     = "${var.product}"
  }

  vpc_id   = "${data.terraform_remote_state.networks.vpc_id}"
}

resource "aws_alb_target_group" "nexus_alb_docker_group_http" {
  count = "${var.enable_nexus_alb}"

  health_check {
    healthy_threshold   = "${var.healthy_threshold}"
    interval            = "${var.interval}"
    matcher             = "${var.matcher}"
    path                = "/"
    port                = "${var.nexus_alb_docker_group_port}"
    protocol            = "HTTP"
    timeout             = "${var.timeout}"
    unhealthy_threshold = "${var.unhealthy_threshold}"
  }

  name     = "${var.vpc_name}-${var.hostname}-docker-g"
  port     = "${var.nexus_alb_docker_group_port}"
  protocol = "HTTP"

  stickiness {
    type = "lb_cookie"
  }

  tags {
    Application = "${var.application}"
    Environment = "${var.environment}"
    Name        = "${var.vpc_name}-${var.hostname}-tg"
    Product     = "${var.product}"
  }

  vpc_id   = "${data.terraform_remote_state.networks.vpc_id}"
}

resource "aws_alb_target_group" "nexus_alb_docker_private_http" {
  count = "${var.enable_nexus_alb}"

  health_check {
    healthy_threshold   = "${var.healthy_threshold}"
    interval            = "${var.interval}"
    matcher             = "${var.matcher}"
    path                = "/"
    port                = "${var.nexus_alb_docker_private_port}"
    protocol            = "HTTP"
    timeout             = "${var.timeout}"
    unhealthy_threshold = "${var.unhealthy_threshold}"
  }

  name     = "${var.vpc_name}-${var.hostname}-docker-priv"
  port     = "${var.nexus_alb_docker_private_port}"
  protocol = "HTTP"

  stickiness {
    type = "lb_cookie"
  }

  tags {
    Application = "${var.application}"
    Environment = "${var.environment}"
    Name        = "${var.vpc_name}-${var.hostname}-tg"
    Product     = "${var.product}"
  }

  vpc_id   = "${data.terraform_remote_state.networks.vpc_id}"
}

resource "aws_alb_target_group_attachment" "nexus_alb_public_http_attachment" {
  count            = "${var.count}"
  port             = "${var.nexus_alb_public_port}"
  target_group_arn = "${aws_alb_target_group.nexus_alb_public_http.arn}"
  target_id        = "${element(module.nexus.instance_id, count.index)}"
}

resource "aws_alb_target_group_attachment" "nexus_alb_docker_group_http_attachment" {
  count            = "${var.count}"
  port             = "${var.nexus_alb_docker_group_port}"
  target_group_arn = "${aws_alb_target_group.nexus_alb_docker_group_http.arn}"
  target_id        = "${element(module.nexus.instance_id, count.index)}"
}

resource "aws_alb_target_group_attachment" "nexus_alb_docker_private_http_attachment" {
  count            = "${var.count}"
  port             = "${var.nexus_alb_docker_private_port}"
  target_group_arn = "${aws_alb_target_group.nexus_alb_docker_private_http.arn}"
  target_id        = "${element(module.nexus.instance_id, count.index)}"
}
