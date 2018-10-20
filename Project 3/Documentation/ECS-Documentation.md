# Amazon Elastic Container Services (ECS)
![Image of ECS](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTkDmRW5CPrryBo5tXGKkph0g51bFkO4qsmDYaXFDQmMEeLWvkVsA)

- ECS Roles
- ECS Cluster
- ECS EC2 Host
- ECS ASG
- ECS Tasks
- ECS Services
- ECS ALB

### ECS Roles
We need to setup roles that ECS can use. We can do that by copy and paste the following code into a new file called `ECS-roles.tf`.

```
# ECS Roles
resource "aws_iam_role" "ecs-instance-role" {
  name = "ecs-instance-role"
  path = "/"
  assume_role_policy = "${data.aws_iam_policy_document.ecs-instance-policy.json}"
}

data "aws_iam_policy_document" "ecs-instance-policy" {
  statement {
  actions = ["sts:AssumeRole"]
principals {
  type = "Service"
  identifiers = ["ec2.amazonaws.com"]
}
}
}

resource "aws_iam_role_policy_attachment" "ecs-instance-role-attachment" {
  role = "${aws_iam_role.ecs-instance-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs-instance-profile" {
  name = "ecs-instance-profile"
  path = "/"
  role = "${aws_iam_role.ecs-instance-role.id}"
  provisioner "local-exec" {
  command = "sleep 60"
}
}

resource "aws_iam_role" "ecs-service-role" {
  name = "ecs-service-role"
  path = "/"
  assume_role_policy = "${data.aws_iam_policy_document.ecs-service-policy.json}"
}

resource "aws_iam_role_policy_attachment" "ecs-service-role-attachment" {
  role = "${aws_iam_role.ecs-service-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

data "aws_iam_policy_document" "ecs-service-policy" {
  statement {
  actions = ["sts:AssumeRole"]
principals {
  type = "Service"
  identifiers = ["ecs.amazonaws.com"]
}
}
}
```
### ECS Cluster
Next is to create a Cluster. Create a new file called `ECS.tf` and pase the following:
```
# Create Cluster
resource "aws_ecs_cluster" "beats-cluster" {
    name = "beats-cluster"
}
```
### ECS EC2 Host
ASG will automatically start new instances if needed, here is the launch-configuration it will use for those instances. It uses an ECS friendly AMI for west-2 region. Paste this into your `ECS.tf` file.

```
# ECS launch configuration
resource "aws_launch_configuration" "ecs-launch-configuration" {
name_prefix           = "ecs-cluster-launch"
image_id              = "ami-00430184c7bb49914"
security_groups       = ["${aws_security_group.NATSG.id}"]
instance_type         = "t2.micro"
key_name              = "${aws_key_pair.deployer.key_name}"
iam_instance_profile  = "${aws_iam_instance_profile.ecs-instance-profile.id}"
user_data             = "#!/bin/bash\necho 'ECS_CLUSTER=beats-cluster' > /etc/ecs/ecs.config\nstart ecs"

root_block_device {
  volume_type = "standard"
  volume_size = 8
  delete_on_termination = true
}

lifecycle {
create_before_destroy = true
}
associate_public_ip_address = "false"
}
```
### ECS ASG
It's time for our Auto-Scaling-Group. Still inside `ECS.tf`, copy and paste the following:
```
# ECS ASG
resource "aws_autoscaling_group" "ecs-autoscaling-group" {
  name = "ecs-autoscaling-group"
  max_size = "2"
  min_size = "1"
  desired_capacity = "2"
  vpc_zone_identifier = ["${aws_subnet.privsubnet1.id}"]
  launch_configuration = "${aws_launch_configuration.ecs-launch-configuration.name}"
  health_check_type = "ELB"
  target_group_arns = ["${aws_alb_target_group.HTTP-Group.arn}"]
tag {
  key = "Name"
  value = "-beats-ecs-asg"
  propagate_at_launch = true
}
}
```
### ECS Tasks
We are now going to declare tasks that our containers in the cluster can use. Create a new file called `ECS-tasks.tf`.

```
resource "aws_ecs_task_definition" "beats-staging" {
  family                = "beats-staging"
  container_definitions = "${file("task-definitions/staging.json")}"
  volume {
    name      = "beats-staging"
    host_path = "/ecs/beats_service"
  }
  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  }
}

resource "aws_ecs_task_definition" "beats-production" {
  family                = "beats-production"
  container_definitions = "${file("task-definitions/production.json")}"
  volume {
    name      = "beats-production"
    host_path = "/ecs/beats_service"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  }
}
```

Create a new folder called `task-definitions` inside your project folder and then create 2 new files called `staging.json` and `production.json`. No need to specify the image since it will be pulled from the ECR later with Lambda.

*staging.json*
```
[
  {
    "name": "beats-staging",
    "image": "service-first",
    "cpu": 10,
    "memory": 512,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
```
*production.json*
```
[
  {
    "name": "beats-production",
    "image": "service-first",
    "cpu": 10,
    "memory": 512,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
```

### ECS Services
We now need Services so that we can use our tasks in the cluster.
```
# ECS Services
## beats-staging task
resource "aws_ecs_service" "beats-staging" {
  name            = "beats-staging"
  cluster         = "${aws_ecs_cluster.beats-cluster.id}"
  task_definition = "${aws_ecs_task_definition.beats-staging.arn}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.staging-HTTP-Group.arn}"
    container_name   = "beats-staging"
    container_port   = 80
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  }
}

# beats-production task
resource "aws_ecs_service" "beats-production" {
  name            = "beats-production"
  cluster         = "${aws_ecs_cluster.beats-cluster.id}"
  task_definition = "${aws_ecs_task_definition.beats-production.arn}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.production-HTTP-Group.arn}"
    container_name   = "beats-production"
    container_port   = 80
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
    }

}

```

### ECS ALB
We can still use our old load balancer found in `Services.tf` but we need to do some adjustments.

```
resource "aws_lb" "Load-Balancer"{
  name               = "Load-Balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups = ["${aws_security_group.NATSG.id}"]
  enable_cross_zone_load_balancing = true
  enable_deletion_protection = false

  subnets            = ["${aws_subnet.pubsubnet1.id}","${aws_subnet.pubsubnet2.id}","${aws_subnet.pubsubnet3.id}"]
}

resource "aws_alb_listener" "HTTP-Listener"{
	load_balancer_arn = "${aws_lb.Load-Balancer.id}"
	port = 80
	default_action {
		type = "redirect"
    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
	}
}

resource "aws_alb_listener" "HTTPS-Listener"{
	load_balancer_arn = "${aws_lb.Load-Balancer.id}"
	port = "443"
  protocol = "HTTPS"
	ssl_policy = "ELBSecurityPolicy-2016-08"
	certificate_arn = "${aws_acm_certificate.cert.arn}"
	default_action {
		type = "forward"
		target_group_arn = "${aws_alb_target_group.production-HTTP-Group.arn}"
	}
}
```

We need to edit our old HTTP-Group and create a new one like this:
```
resource "aws_alb_target_group" "staging-HTTP-Group" {
  name     = "staging-HTTP-Group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.main.id}"
  depends_on = ["aws_lb.Load-Balancer"]
}

resource "aws_alb_target_group" "production-HTTP-Group" {
  name     = "production-HTTP-Group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.main.id}"
  depends_on = ["aws_lb.Load-Balancer"]
}

resource "aws_lb_listener_rule" "beats-staging" {
  listener_arn = "${aws_alb_listener.HTTPS-Listener.arn}"
  priority = 10
  action = {
    type = "forward"
    target_group_arn = "${aws_alb_target_group.staging-HTTP-Group.id}"
  }
  condition = {
    field = "host-header"
    values = ["*staging.fa480.club"]
  }
}

```
