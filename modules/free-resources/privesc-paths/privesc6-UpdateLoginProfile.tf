resource "aws_iam_policy" "privesc6-UpdateLoginProfile" {
  name        = "privesc6-UpdateLoginProfile"
  path        = "/"
  description = "Allows privesc via iam:UpdateLoginProfile"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "iam:UpdateLoginProfile"
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "a1f7ed4f-aa49-4403-84a6-85d6aff42ef6"
  }
}

resource "aws_iam_role" "privesc6-UpdateLoginProfile-role" {
  name = "privesc6-UpdateLoginProfile-role"
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
    yor_trace = "84fdd297-dbd3-46e5-bd32-2a93add3cf09"
  }
}

resource "aws_iam_user" "privesc6-UpdateLoginProfile-user" {
  name = "privesc6-UpdateLoginProfile-user"
  path = "/"
  tags = {
    yor_trace = "b6fa5556-5f1c-4bd9-ae71-d0d11f2df0fd"
  }
}

resource "aws_iam_access_key" "privesc6-UpdateLoginProfile-user" {
  user = aws_iam_user.privesc6-UpdateLoginProfile-user.name
}


resource "aws_iam_user_policy_attachment" "privesc6-UpdateLoginProfile-user-attach-policy" {
  user       = aws_iam_user.privesc6-UpdateLoginProfile-user.name
  policy_arn = aws_iam_policy.privesc6-UpdateLoginProfile.arn
}

resource "aws_iam_role_policy_attachment" "privesc6-UpdateLoginProfile-role-attach-policy" {
  role       = aws_iam_role.privesc6-UpdateLoginProfile-role.name
  policy_arn = aws_iam_policy.privesc6-UpdateLoginProfile.arn
}
