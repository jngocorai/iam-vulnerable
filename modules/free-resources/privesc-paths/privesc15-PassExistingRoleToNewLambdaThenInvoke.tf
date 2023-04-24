resource "aws_iam_policy" "privesc15-PassExistingRoleToNewLambdaThenInvoke" {
  name        = "privesc15-PassExistingRoleToNewLambdaThenInvoke"
  path        = "/"
  description = "Allows privesc via lambda:createfunction, invokefunction and iam:passrole"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iam:PassRole",
          "lambda:CreateFunction",
          "lambda:InvokeFunction"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "1cccea4a-6b0b-4881-b7b9-9466279fe150"
  }
}

resource "aws_iam_role" "privesc15-PassExistingRoleToNewLambdaThenInvoke-role" {
  name = "privesc15-PassExistingRoleToNewLambdaThenInvoke-role"
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
    yor_trace = "89dd43e8-1275-44ce-b4a8-6677a4fcb3a1"
  }
}

resource "aws_iam_user" "privesc15-PassExistingRoleToNewLambdaThenInvoke-user" {
  name = "privesc15-PassExistingRoleToNewLambdaThenInvoke-user"
  path = "/"
  tags = {
    yor_trace = "32de7ff6-ddab-4468-857b-86666da0f87b"
  }
}

resource "aws_iam_access_key" "privesc15-PassExistingRoleToNewLambdaThenInvoke-user" {
  user = aws_iam_user.privesc15-PassExistingRoleToNewLambdaThenInvoke-user.name
}


resource "aws_iam_user_policy_attachment" "privesc15-PassExistingRoleToNewLambdaThenInvoke-user-attach-policy" {
  user       = aws_iam_user.privesc15-PassExistingRoleToNewLambdaThenInvoke-user.name
  policy_arn = aws_iam_policy.privesc15-PassExistingRoleToNewLambdaThenInvoke.arn
}

resource "aws_iam_role_policy_attachment" "privesc15-PassExistingRoleToNewLambdaThenInvoke-role-attach-policy" {
  role       = aws_iam_role.privesc15-PassExistingRoleToNewLambdaThenInvoke-role.name
  policy_arn = aws_iam_policy.privesc15-PassExistingRoleToNewLambdaThenInvoke.arn
}
