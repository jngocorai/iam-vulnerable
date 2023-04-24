resource "aws_iam_policy" "privesc-codeBuildCreateProjectPassRole-policy" {
  name        = "privesc-codeBuildCreateProjectPassRole-policy"
  path        = "/"
  description = "Allows privesc via codeBuild"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "codebuild:CreateProject",
          "codebuild:StartBuild",
          "codebuild:StartBuildBatch",
          "iam:PassRole",
          "iam:ListRoles"
        ]
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "3a6806d5-920b-4c9a-b6ee-ec96db75fd5c"
  }
}



resource "aws_iam_role" "privesc-codeBuildCreateProjectPassRole-role" {
  name = "privesc-codeBuildCreateProjectPassRole-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = var.aws_assume_role_arn
        }
      },
    ]
  })
  tags = {
    yor_trace = "a3ef7b18-f368-4a8a-8279-c2fecffdebf2"
  }
}


resource "aws_iam_user" "privesc-codeBuildCreateProjectPassRole-user" {
  name = "privesc-codeBuildCreateProjectPassRole-user"
  path = "/"
  tags = {
    yor_trace = "fddcbd5a-8387-4367-b163-43e2b62dd8e2"
  }
}

resource "aws_iam_access_key" "privesc-codeBuildCreateProjectPassRole-user" {
  user = aws_iam_user.privesc-codeBuildCreateProjectPassRole-user.name
}



resource "aws_iam_user_policy_attachment" "privesc-codeBuildCreateProjectPassRole-user-attach-policy" {
  user       = aws_iam_user.privesc-codeBuildCreateProjectPassRole-user.name
  policy_arn = aws_iam_policy.privesc-codeBuildCreateProjectPassRole-policy.arn
}


resource "aws_iam_role_policy_attachment" "privesc-codeBuildCreateProjectPassRole-role-attach-policy" {
  role       = aws_iam_role.privesc-codeBuildCreateProjectPassRole-role.name
  policy_arn = aws_iam_policy.privesc-codeBuildCreateProjectPassRole-policy.arn

}

