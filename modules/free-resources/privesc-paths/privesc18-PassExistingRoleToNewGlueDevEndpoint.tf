resource "aws_iam_policy" "privesc18-PassExistingRoleToNewGlueDevEndpoint" {
  name        = "privesc18-PassExistingRoleToNewGlueDevEndpoint"
  path        = "/"
  description = "Allows privesc via glue:CreateDevEndpoint, glue:GetDevEndpoint and iam:passrole"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "glue:CreateDevEndpoint",
          "glue:GetDevEndpoint",
          "iam:PassRole"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "31dee18e-342a-4a27-8680-537d08d19cb3"
  }
}

resource "aws_iam_role" "privesc18-PassExistingRoleToNewGlueDevEndpoint-role" {
  name = "privesc18-PassExistingRoleToNewGlueDevEndpoint-role"
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
    yor_trace = "e3ea9bc3-8a58-45ed-9463-b70cadef3540"
  }
}

resource "aws_iam_user" "privesc18-PassExistingRoleToNewGlueDevEndpoint-user" {
  name = "privesc18-PassExistingRoleToNewGlueDevEndpoint-user"
  path = "/"
  tags = {
    yor_trace = "75372081-c495-467a-890a-13a304884bf6"
  }
}

resource "aws_iam_access_key" "privesc18-PassExistingRoleToNewGlueDevEndpoint-user" {
  user = aws_iam_user.privesc18-PassExistingRoleToNewGlueDevEndpoint-user.name
}


resource "aws_iam_user_policy_attachment" "privesc18-PassExistingRoleToNewGlueDevEndpoint-user-attach-policy" {
  user       = aws_iam_user.privesc18-PassExistingRoleToNewGlueDevEndpoint-user.name
  policy_arn = aws_iam_policy.privesc18-PassExistingRoleToNewGlueDevEndpoint.arn
}

resource "aws_iam_role_policy_attachment" "privesc18-PassExistingRoleToNewGlueDevEndpoint-role-attach-policy" {
  role       = aws_iam_role.privesc18-PassExistingRoleToNewGlueDevEndpoint-role.name
  policy_arn = aws_iam_policy.privesc18-PassExistingRoleToNewGlueDevEndpoint.arn
}
