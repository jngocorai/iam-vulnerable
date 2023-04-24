resource "aws_iam_policy" "privesc9-AttachRolePolicy" {
  name        = "privesc9-AttachRolePolicy"
  path        = "/"
  description = "Allows privesc via iam:AttachRolePolicy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "iam:AttachRolePolicy"
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "190ae151-9108-4081-bb10-cc09ae78db2e"
  }
}

resource "aws_iam_role" "privesc9-AttachRolePolicy-role" {
  name = "privesc9-AttachRolePolicy-role"
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
    yor_trace = "a084be7d-cda2-4aba-b7d5-d005d43d6922"
  }
}

resource "aws_iam_user" "privesc9-AttachRolePolicy-user" {
  name = "privesc9-AttachRolePolicy-user"
  path = "/"
  tags = {
    yor_trace = "a654e4ba-7cd9-4a98-81fc-a2be2727a87c"
  }
}

resource "aws_iam_access_key" "privesc9-AttachRolePolicy-user" {
  user = aws_iam_user.privesc9-AttachRolePolicy-user.name
}


resource "aws_iam_user_policy_attachment" "privesc9-AttachRolePolicy-user-attach-policy" {
  user       = aws_iam_user.privesc9-AttachRolePolicy-user.name
  policy_arn = aws_iam_policy.privesc9-AttachRolePolicy.arn
}

resource "aws_iam_role_policy_attachment" "privesc9-AttachRolePolicy-role-attach-policy" {
  role       = aws_iam_role.privesc9-AttachRolePolicy-role.name
  policy_arn = aws_iam_policy.privesc9-AttachRolePolicy.arn
}