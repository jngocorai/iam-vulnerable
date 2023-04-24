resource "aws_iam_policy" "privesc13-AddUserToGroup" {
  name        = "privesc13-AddUserToGroup"
  path        = "/"
  description = "Allows privesc via iam:AddUserToGroup"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "iam:AddUserToGroup"
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "f17c31af-39bb-4bc1-bc7b-ea9de9faa5aa"
  }
}

resource "aws_iam_role" "privesc13-AddUserToGroup-role" {
  name = "privesc13-AddUserToGroup-role"
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
    yor_trace = "10d3b2bb-1b64-4caf-b51e-26242bf96347"
  }
}

resource "aws_iam_user" "privesc13-AddUserToGroup-user" {
  name = "privesc13-AddUserToGroup-user"
  path = "/"
  tags = {
    yor_trace = "16e33611-036d-4785-afa7-dcb5d1b870f2"
  }
}

resource "aws_iam_access_key" "privesc13-AddUserToGroup-user" {
  user = aws_iam_user.privesc13-AddUserToGroup-user.name
}


resource "aws_iam_user_policy_attachment" "privesc13-AddUserToGroup-user-attach-policy" {
  user       = aws_iam_user.privesc13-AddUserToGroup-user.name
  policy_arn = aws_iam_policy.privesc13-AddUserToGroup.arn
}

resource "aws_iam_role_policy_attachment" "privesc13-AddUserToGroup-role-attach-policy" {
  role       = aws_iam_role.privesc13-AddUserToGroup-role.name
  policy_arn = aws_iam_policy.privesc13-AddUserToGroup.arn
}


