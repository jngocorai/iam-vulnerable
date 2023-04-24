resource "aws_iam_policy" "privesc-ssmStartSession-policy" {
  name        = "privesc-ssmStartSession-policy"
  path        = "/"
  description = "Allows privesc via targeted ssm"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ssm:StartSession",
          "ssm:DescribeSessions",
          "ssm:GetConnectionStatus",
          "ssm:DescribeInstanceProperties",
          "ssm:TerminateSession",
          "ssm:ResumeSession"
        ]
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "e8dee224-42a2-461b-ab4c-1c1db05173e7"
  }
}



resource "aws_iam_role" "privesc-ssmStartSession-role" {
  name = "privesc-ssmStartSession-role"
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
    yor_trace = "4662f71d-2c7e-48cc-9633-508207a0847c"
  }
}


resource "aws_iam_user" "privesc-ssmStartSession-user" {
  name = "privesc-ssmStartSession-user"
  path = "/"
  tags = {
    yor_trace = "ca73dad0-0a67-49a9-92a2-5eac32ba131f"
  }
}

resource "aws_iam_access_key" "privesc-ssmStartSession-user" {
  user = aws_iam_user.privesc-ssmStartSession-user.name
}



resource "aws_iam_user_policy_attachment" "privesc-ssmStartSession-user-attach-policy" {
  user       = aws_iam_user.privesc-ssmStartSession-user.name
  policy_arn = aws_iam_policy.privesc-ssmStartSession-policy.arn
}


resource "aws_iam_role_policy_attachment" "privesc-ssmStartSession-role-attach-policy" {
  role       = aws_iam_role.privesc-ssmStartSession-role.name
  policy_arn = aws_iam_policy.privesc-ssmStartSession-policy.arn

}

