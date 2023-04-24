resource "aws_iam_policy" "fp2-allow-all" {
  name        = "fp2-allow-all"
  path        = "/"
  description = "Allows everything"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow",
        Action   = "*",
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "c9696230-5c3a-4d30-9a5c-6ff7ae654618"
  }
}

resource "aws_iam_policy" "deny-all" {
  name        = "deny-all"
  path        = "/"
  description = "Denies everything"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Deny",
        Action   = "*",
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "b147d53b-5215-46e1-963d-eb8e00e58159"
  }
}




resource "aws_iam_role" "fp2-allow-and-deny-multiple-policies-role" {
  name = "fp2-allow-and-deny-multiple-policies-role"
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
    yor_trace = "fc94b024-a60e-4ab4-b71a-5462e792e5c4"
  }
}

resource "aws_iam_user" "fp2-allow-and-deny-multiple-policies-user" {
  name = "fp2-allow-and-deny-multiple-policies-user"
  path = "/"
  tags = {
    yor_trace = "c51547e5-0604-4758-8e71-559a1253e0ad"
  }
}

resource "aws_iam_access_key" "fp2-allow-and-deny-multiple-policies-user" {
  user = aws_iam_user.fp2-allow-and-deny-multiple-policies-user.name
}



resource "aws_iam_user_policy_attachment" "fp2-allow-and-deny-attach-allow-to-user" {
  user       = aws_iam_user.fp2-allow-and-deny-multiple-policies-user.name
  policy_arn = aws_iam_policy.fp2-allow-all.arn
}

resource "aws_iam_user_policy_attachment" "fp2-allow-and-deny-attach-deny-to-user" {
  user       = aws_iam_user.fp2-allow-and-deny-multiple-policies-user.name
  policy_arn = aws_iam_policy.deny-all.arn
}

resource "aws_iam_role_policy_attachment" "fp2-allow-and-deny-attach-allow-to-role" {
  role       = aws_iam_role.fp2-allow-and-deny-multiple-policies-role.name
  policy_arn = aws_iam_policy.fp2-allow-all.arn

}

resource "aws_iam_role_policy_attachment" "fp2-allow-and-deny-attach-deny-to-roler" {
  role       = aws_iam_role.fp2-allow-and-deny-multiple-policies-role.name
  policy_arn = aws_iam_policy.deny-all.arn

}
