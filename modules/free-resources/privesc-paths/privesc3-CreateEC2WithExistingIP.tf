resource "aws_iam_policy" "privesc3-CreateEC2WithExistingInstanceProfile" {
  name        = "privesc3-CreateEC2WithExistingInstanceProfile"
  path        = "/"
  description = "Allows privesc via ec2:RunInstances and iam:passrole and includes some other helpful permissions"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iam:PassRole",
          "ec2:DescribeInstances",
          "ec2:RunInstances",
          "ec2:CreateKeyPair",
          "ec2:AssociateIamInstanceProfile"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "f5e76f4e-ab41-4ea0-b33c-8ddf88cd633a"
  }
}

resource "aws_iam_role" "privesc3-CreateEC2WithExistingInstanceProfile-role" {
  name = "privesc3-CreateEC2WithExistingInstanceProfile-role"
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
    yor_trace = "9bfe2000-dad2-452e-88da-96c43a65287b"
  }
}



resource "aws_iam_user" "privesc3-CreateEC2WithExistingInstanceProfile-user" {
  name = "privesc3-CreateEC2WithExistingInstanceProfile-user"
  path = "/"
  tags = {
    yor_trace = "84df96d5-5e51-49a3-91b7-3b19b7535653"
  }
}


resource "aws_iam_access_key" "privesc3-CreateEC2WithExistingInstanceProfile-user" {
  user = aws_iam_user.privesc3-CreateEC2WithExistingInstanceProfile-user.name
}


resource "aws_iam_user_policy_attachment" "privesc3-CreateEC2WithExistingInstanceProfile-user-attach-policy" {
  user       = aws_iam_user.privesc3-CreateEC2WithExistingInstanceProfile-user.name
  policy_arn = aws_iam_policy.privesc3-CreateEC2WithExistingInstanceProfile.arn
}

resource "aws_iam_role_policy_attachment" "privesc3-CreateEC2WithExistingInstanceProfile-role-attach-policy" {
  role       = aws_iam_role.privesc3-CreateEC2WithExistingInstanceProfile-role.name
  policy_arn = aws_iam_policy.privesc3-CreateEC2WithExistingInstanceProfile.arn

}


