resource "aws_ecs_task_definition" "service" {
  family                = "service"
  container_definitions = "${file("task-definitions/service.json")}"
  volume {
    name      = "service"
    host_path = "/ecs/beats_service"
  }
  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  }
}

resource "aws_ecs_service" "service" {
  name            = "service"
  cluster         = "${aws_ecs_cluster.beats-cluster.id}"
  task_definition = "${aws_ecs_task_definition.service.arn}"


  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
    }

}
