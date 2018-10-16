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

resource "aws_ecs_service" "beats-staging" {
  name            = "beats-staging"
  cluster         = "${aws_ecs_cluster.beats-cluster.id}"
  task_definition = "${aws_ecs_task_definition.beats-staging.arn}"

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

resource "aws_ecs_service" "beats-production" {
  name            = "beats-production"
  cluster         = "${aws_ecs_cluster.beats-cluster.id}"
  task_definition = "${aws_ecs_task_definition.beats-production.arn}"


  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
    }

}
