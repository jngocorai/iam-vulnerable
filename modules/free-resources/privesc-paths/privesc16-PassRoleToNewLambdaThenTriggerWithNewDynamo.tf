resource "aws_iam_policy" "privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo" {
  name        = "privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo"
  path        = "/"
  description = "Allows privesc via lambda:createfunction, CreateEventSourceMapping and iam:passrole"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "lambda:CreateFunction",
          "iam:PassRole",
          "lambda:CreateEventSourceMapping"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "aa90693b-116d-4600-a025-d9c0c9b32b40"
  }
}

resource "aws_iam_role" "privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo-role" {
  name = "privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo-role"
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
    yor_trace = "157856b1-d30a-4890-9937-f20e6452e4c5"
  }
}

resource "aws_iam_user" "privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo-user" {
  name = "privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo-user"
  path = "/"
  tags = {
    yor_trace = "f069e7a7-58d8-463f-8ed6-c9623264a4ac"
  }
}

resource "aws_iam_access_key" "privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo-user" {
  user = aws_iam_user.privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo-user.name
}


resource "aws_iam_user_policy_attachment" "privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo-user-attach-policy" {
  user       = aws_iam_user.privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo-user.name
  policy_arn = aws_iam_policy.privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo.arn
}

resource "aws_iam_role_policy_attachment" "privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo-role-attach-policy" {
  role       = aws_iam_role.privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo-role.name
  policy_arn = aws_iam_policy.privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo.arn
}