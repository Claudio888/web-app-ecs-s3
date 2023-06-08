resource "aws_ecr_repository" "api-repo" {
  name                 = "api"
  image_tag_mutability = "MUTABLE"

  tags = {
    Terraform   = "true"
    Environment = "prod"
    Team        = "devops"
    App         = "web-app"
  }
}