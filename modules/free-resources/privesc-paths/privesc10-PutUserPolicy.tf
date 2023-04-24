resource "aws_iam_policy" "privesc10-PutUserPolicy" {
  name        = "privesc10-PutUserPolicy"
  path        = "/"
  description = "Allows privesc via iam:PutUserPolicy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "iam:PutUserPolicy"
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "c45e0c21-3026-4738-b4c0-fd6748b69284"
  }
}

resource "aws_iam_role" "privesc10-PutUserPolicy-role" {
  name = "privesc10-PutUserPolicy-role"
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
    yor_trace = "0db1f39d-b03f-4a99-8cea-d73aac992391"
  }
}

resource "aws_iam_user" "privesc10-PutUserPolicy-user" {
  name = "privesc10-PutUserPolicy-user"
  path = "/"
  tags = {
    yor_trace = "7e6a23b2-deb1-44c3-bffe-087633aeedc5"
  }
}

resource "aws_iam_access_key" "privesc10-PutUserPolicy-user" {
  user = aws_iam_user.privesc10-PutUserPolicy-user.name
}


resource "aws_iam_user_policy_attachment" "privesc10-PutUserPolicy-user-attach-policy" {
  user       = aws_iam_user.privesc10-PutUserPolicy-user.name
  policy_arn = aws_iam_policy.privesc10-PutUserPolicy.arn
}

resource "aws_iam_role_policy_attachment" "privesc10-PutUserPolicy-role-attach-policy" {
  role       = aws_iam_role.privesc10-PutUserPolicy-role.name
  policy_arn = aws_iam_policy.privesc10-PutUserPolicy.arn
}