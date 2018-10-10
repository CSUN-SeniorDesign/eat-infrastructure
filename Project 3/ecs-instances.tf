# Create Cluster
resource "aws_ecs_cluster" "beats_cluster" {
    name = "beats-cluster"
}
