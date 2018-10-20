# Amazon Elastic Container Registry (ECR)
![Image of ECR](https://cdn-images.postach.io/aa0e0e8e-5932-48c5-bbd5-bb782bc5caef/b1824442-f97a-4615-b653-32bd2ffa3dbf/a4d52970-fb96-4d30-86b5-b5f85dfcac20.gif)

- ECR

### ECR
We need to create a repository to hold our docker images. Copy and paste the following code into a new file called `ECR.tf`. The code below creates a new repository with the name *beats_repo*. The second code block outputs the URL to your newly created repository.
```
# ECR repository
resource "aws_ecr_repository" "beats_repo" {
  name = "beats_repo"
}

# Output ECR URL
output "beats-repository-URL" {
  value = "${aws_ecr_repository.beats_repo.repository_url}"
}

```
