resource "aws_launch_configuration" "ecs-launch-configuration" {
 name = "ecs-launch-configuration"
 image_id = "ami-40ddb938"
 instance_type = "t2.micro"
 iam_instance_profile = "${aws_iam_instance_profile.ecs-instance-profile.id}"
 user_data = "#!/bin/bash\necho ECS_CLUSTER=my_cluster > /etc/ecs/ecs.config"

root_block_device {
 volume_type = "standard"
 volume_size = 100
 delete_on_termination = true
 }

lifecycle {
 create_before_destroy = true
 }

associate_public_ip_address = "false"
 key_name = "deployer-key"
 }

 resource "aws_autoscaling_group" "ecs-autoscaling-group" {
 name = "ecs-autoscaling-group"
 max_size = "2"
 min_size = "1"
 desired_capacity = "1"


 vpc_zone_identifier  = ["${aws_subnet.privsubnet1.id}"]
 launch_configuration = "${aws_launch_configuration.ecs-launch-configuration.name}"
 health_check_type = "ELB"

tag {
 key = "Name"
 value = "ECS-myecscluster"
 propagate_at_launch = true
 }
 }

resource "aws_ecs_cluster" "test-ecs-cluster" {
 name = "myecscluster"
 }
