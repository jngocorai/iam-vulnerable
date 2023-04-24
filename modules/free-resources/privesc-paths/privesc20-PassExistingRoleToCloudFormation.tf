resource "aws_iam_policy" "privesc20-PassExistingRoleToCloudFormation" {
  name        = "privesc20-PassExistingRoleToCloudFormation"
  path        = "/"
  description = "Allows privesc via iam:PassRole, cloudformation:CreateStack, and cloudformation:DescribeStacks"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "iam:PassRole",
          "cloudformation:CreateStack",
          "cloudformation:DescribeStacks"
        ],
        "Resource" : "*"
      }
    ]
  })
  tags = {
    yor_trace = "1b68e0ce-42b6-49f9-8c95-5dd99fc601f5"
  }
}

resource "aws_iam_role" "privesc20-PassExistingRoleToCloudFormation-role" {
  name = "privesc20-PassExistingRoleToCloudFormation-role"
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
    yor_trace = "8de91188-e6c4-4c78-a892-131c5b9d9d8f"
  }
}

resource "aws_iam_user" "privesc20-PassExistingRoleToCloudFormation-user" {
  name = "privesc20-PassExistingRoleToCloudFormation-user"
  path = "/"
  tags = {
    yor_trace = "a24516b1-da4c-4e3d-b9c6-2315aae6907a"
  }
}

resource "aws_iam_access_key" "privesc20-PassExistingRoleToCloudFormation-user" {
  user = aws_iam_user.privesc20-PassExistingRoleToCloudFormation-user.name
}


resource "aws_iam_user_policy_attachment" "privesc20-PassExistingRoleToCloudFormation-user-attach-policy" {
  user       = aws_iam_user.privesc20-PassExistingRoleToCloudFormation-user.name
  policy_arn = aws_iam_policy.privesc20-PassExistingRoleToCloudFormation.arn
}

resource "aws_iam_role_policy_attachment" "privesc20-PassExistingRoleToCloudFormation-role-attach-policy" {
  role       = aws_iam_role.privesc20-PassExistingRoleToCloudFormation-role.name
  policy_arn = aws_iam_policy.privesc20-PassExistingRoleToCloudFormation.arn
}
