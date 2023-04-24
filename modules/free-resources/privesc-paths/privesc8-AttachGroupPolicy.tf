resource "aws_iam_policy" "privesc8-AttachGroupPolicy" {
  name        = "privesc8-AttachGroupPolicy"
  path        = "/"
  description = "Allows privesc via iam:AttachGroupPolicy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "iam:AttachGroupPolicy"
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "d0b35bc1-b5c7-4d7c-bb4d-fe7419ae6951"
  }
}

resource "aws_iam_role" "privesc8-AttachGroupPolicy-role" {
  name = "privesc8-AttachGroupPolicy-role"
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
    yor_trace = "e1b7f6a3-6649-4c3b-9ce3-a865fdaf33a9"
  }
}

resource "aws_iam_user" "privesc8-AttachGroupPolicy-user" {
  name = "privesc8-AttachGroupPolicy-user"
  path = "/"
  tags = {
    yor_trace = "c23d4c5d-0303-4152-b8d3-d3c27840a62d"
  }
}

resource "aws_iam_access_key" "privesc8-AttachGroupPolicy-user" {
  user = aws_iam_user.privesc8-AttachGroupPolicy-user.name
}


resource "aws_iam_user_policy_attachment" "privesc8-AttachGroupPolicy-user-attach-policy" {
  user       = aws_iam_user.privesc8-AttachGroupPolicy-user.name
  policy_arn = aws_iam_policy.privesc8-AttachGroupPolicy.arn
}

resource "aws_iam_role_policy_attachment" "privesc8-AttachGroupPolicy-role-attach-policy" {
  role       = aws_iam_role.privesc8-AttachGroupPolicy-role.name
  policy_arn = aws_iam_policy.privesc8-AttachGroupPolicy.arn
}


resource "aws_iam_group" "privesc8-AttachGroupPolicy-group" {
  name = "privesc8-AttachGroupPolicy-group"
  path = "/"
}

resource "aws_iam_group_membership" "privesc8-AttachGroupPolicy-group-membership" {
  name = "privesc8-AttachGroupPolicy-group-membership"

  users = [
    aws_iam_user.privesc8-AttachGroupPolicy-user.name
  ]

  group = aws_iam_group.privesc8-AttachGroupPolicy-group.name
}