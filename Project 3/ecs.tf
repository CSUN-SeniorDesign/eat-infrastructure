# Create Cluster
resource "aws_ecs_cluster" "beats-cluster" {
  name = "beats-cluster"
}

# ECS launch configuration
resource "aws_launch_configuration" "ecs-launch-config"{
  name_prefix           = "ecs-instance-"
  image_id              = "ami-03aeeee0fc4b4a35c"
  instance_type         = "t2.micro"
  security_groups       = ["${aws_security_group.NATSG.id}"]
  ebs_optimized         = false
  key_name              = "${aws_key_pair.deployer.key_name}"
  iam_instance_profile  = "${aws_iam_instance_profile.IP.arn}"
  user_data             = "#!/bin/bash\necho 'ECS_CLUSTER=beats-cluster' > /etc/ecs/ecs.config\nstart ecs"

  lifecycle {
    create_before_destroy = true
  }
}

# Task
resource "aws_ecs_task_definition" "test-http" {
    family = "test-http"
    container_definitions = "${file("task-definitions/test-http.json")}"
}

# Service
# ELB with each service
