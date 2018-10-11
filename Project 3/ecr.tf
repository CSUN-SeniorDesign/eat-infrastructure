# Create ECR
resource "aws_ecr_repository" "beats_repo" {
  name = "beats_repo"
}

# Output URL
output "beats-repository-URL" {
  value = "${aws_ecr_repository.beats_repo.repository_url}"
}
