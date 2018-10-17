
# ECS launch configuration
resource "aws_launch_configuration" "ecs-launch-configuration" {
name                  = "ecs-launch-configuration"
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

resource "aws_autoscaling_group" "ecs-autoscaling-group" {
  name = "ecs-autoscaling-group"
  max_size = "2"
  min_size = "1"
  desired_capacity = "2"
  vpc_zone_identifier = ["${aws_subnet.privsubnet1.id}"]
  launch_configuration = "${aws_launch_configuration.ecs-launch-configuration.name}"
  health_check_type = "ELB"
  target_group_arn = "${aws_alb_target_group.HTTP-Group.arn}"

tag {
  key = "Name"
  value = "-beats-ecs-asg"
  propagate_at_launch = true
}
}

resource "aws_ecs_cluster" "beats-cluster" {
  name = "beats-cluster"
}
