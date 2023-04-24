resource "aws_iam_policy" "privesc-CloudFormationUpdateStack" {
  name        = "privesc-CloudFormationUpdateStack"
  path        = "/"
  description = "Allows privesc via cloudformation:UpdateStack"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "cloudformation:UpdateStack",
          "cloudformation:DescribeStacks"
        ],
        "Resource" : "*"
      }
    ]
  })
  tags = {
    yor_trace = "208a11de-2d88-4930-b0b7-d3abc75a633e"
  }
}

resource "aws_iam_role" "privesc-CloudFormationUpdateStack-role" {
  name = "privesc-CloudFormationUpdateStack-role"
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
    yor_trace = "a4ae0441-284d-429c-916c-27e3eaa4a67f"
  }
}

resource "aws_iam_user" "privesc-CloudFormationUpdateStack-user" {
  name = "privesc-CloudFormationUpdateStack-user"
  path = "/"
  tags = {
    yor_trace = "419d4e80-b6f6-4aa5-a2c0-09414d840bb6"
  }
}

resource "aws_iam_access_key" "privesc-CloudFormationUpdateStack-user" {
  user = aws_iam_user.privesc-CloudFormationUpdateStack-user.name
}


resource "aws_iam_user_policy_attachment" "privesc-CloudFormationUpdateStack-user-attach-policy" {
  user       = aws_iam_user.privesc-CloudFormationUpdateStack-user.name
  policy_arn = aws_iam_policy.privesc-CloudFormationUpdateStack.arn
}

resource "aws_iam_role_policy_attachment" "privesc-CloudFormationUpdateStack-role-attach-policy" {
  role       = aws_iam_role.privesc-CloudFormationUpdateStack-role.name
  policy_arn = aws_iam_policy.privesc-CloudFormationUpdateStack.arn
}
