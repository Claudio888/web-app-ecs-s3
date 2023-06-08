data "aws_iam_policy" "ecs-task-execution-search" {
  name = "AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs-task-execution-role" {
  name               = "EcsTaskExec"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy" {
  role       = aws_iam_role.ecs-task-execution-role.name
  policy_arn = data.aws_iam_policy.ecs-task-execution-search.arn
}

