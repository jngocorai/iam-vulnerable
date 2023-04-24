resource "aws_iam_policy" "privesc5-CreateLoginProfile" {
  name        = "privesc5-CreateLoginProfile"
  path        = "/"
  description = "Allows privesc via iam:CreateLoginProfile"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "iam:CreateLoginProfile"
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "48459caf-75b0-4336-b7c2-3e5ee12f5870"
  }
}

resource "aws_iam_role" "privesc5-CreateLoginProfile-role" {
  name = "privesc5-CreateLoginProfile-role"
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
    yor_trace = "07d1ef7c-28d5-43bb-9d5c-c35548b630e3"
  }
}

resource "aws_iam_user" "privesc5-CreateLoginProfile-user" {
  name = "privesc5-CreateLoginProfile-user"
  path = "/"
  tags = {
    yor_trace = "fccf74b1-050d-4fb7-ab01-5b45f35e38eb"
  }
}

resource "aws_iam_access_key" "privesc5-CreateLoginProfile-user" {
  user = aws_iam_user.privesc5-CreateLoginProfile-user.name
}


resource "aws_iam_user_policy_attachment" "privesc5-CreateLoginProfile-user-attach-policy" {
  user       = aws_iam_user.privesc5-CreateLoginProfile-user.name
  policy_arn = aws_iam_policy.privesc5-CreateLoginProfile.arn
}

resource "aws_iam_role_policy_attachment" "privesc5-CreateLoginProfile-role-attach-policy" {
  role       = aws_iam_role.privesc5-CreateLoginProfile-role.name
  policy_arn = aws_iam_policy.privesc5-CreateLoginProfile.arn
}