# Does the tool evaluate deny's first before allows like AWS does? Many tools ignore or incorrectly handle DENY actions

resource "aws_iam_policy" "fp3-deny-iam" {
  name        = "fp3-deny-iam"
  path        = "/"
  description = ""

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Deny"
        Action   = "iam:*"
        Resource = "*"
      }
    ]
  })
  tags = {
    yor_trace = "6f5761df-c128-42d0-80fb-2213d39b4fab"
  }
}

resource "aws_iam_role" "fp3-deny-iam-role" {
  name = "fp3-deny-iam-role"
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
    yor_trace = "89337d54-667d-45c4-8954-0eb99e529451"
  }
}

resource "aws_iam_user" "fp3-deny-iam-user" {
  name = "fp3-deny-iam-user"
  path = "/"
  tags = {
    yor_trace = "7847ac14-7902-4a51-bb9a-e788ff3f6d5c"
  }
}

resource "aws_iam_access_key" "fp3-deny-iam-user" {
  user = aws_iam_user.fp3-deny-iam-user.name
}

resource "aws_iam_user_policy_attachment" "fp3-deny-iam-user-attach-policy" {
  user       = aws_iam_user.fp3-deny-iam-user.name
  policy_arn = aws_iam_policy.fp3-deny-iam.arn
}


resource "aws_iam_role_policy_attachment" "fp3-deny-iam-role-attach-policy" {
  role       = aws_iam_role.fp3-deny-iam-role.name
  policy_arn = aws_iam_policy.fp3-deny-iam.arn

}
