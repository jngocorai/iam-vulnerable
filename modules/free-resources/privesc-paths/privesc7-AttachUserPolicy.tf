resource "aws_iam_policy" "privesc7-AttachUserPolicy" {
  name        = "privesc7-AttachUserPolicy"
  path        = "/"
  description = "Allows privesc via iam:AttachUserPolicy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "iam:AttachUserPolicy"
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "664e601b-35eb-48c3-8026-e4619c7f468d"
  }
}

resource "aws_iam_role" "privesc7-AttachUserPolicy-role" {
  name = "privesc7-AttachUserPolicy-role"
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
    yor_trace = "8f31220d-25cb-4f50-a094-f3b2e5bcdcc8"
  }
}

resource "aws_iam_user" "privesc7-AttachUserPolicy-user" {
  name = "privesc7-AttachUserPolicy-user"
  path = "/"
  tags = {
    yor_trace = "2e6aa7ab-f91c-45fb-a18d-bf088d6f00c9"
  }
}

resource "aws_iam_access_key" "privesc7-AttachUserPolicy-user" {
  user = aws_iam_user.privesc7-AttachUserPolicy-user.name
}


resource "aws_iam_user_policy_attachment" "privesc7-AttachUserPolicy-user-attach-policy" {
  user       = aws_iam_user.privesc7-AttachUserPolicy-user.name
  policy_arn = aws_iam_policy.privesc7-AttachUserPolicy.arn
}

resource "aws_iam_role_policy_attachment" "privesc7-AttachUserPolicy-role-attach-policy" {
  role       = aws_iam_role.privesc7-AttachUserPolicy-role.name
  policy_arn = aws_iam_policy.privesc7-AttachUserPolicy.arn
}