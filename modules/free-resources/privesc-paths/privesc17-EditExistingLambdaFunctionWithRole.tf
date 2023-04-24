resource "aws_iam_policy" "privesc17-EditExistingLambdaFunctionWithRole" {
  name        = "privesc17-EditExistingLambdaFunctionWithRole"
  path        = "/"
  description = "Allows privesc via lambda:UpdateFunctionCode"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "lambda:UpdateFunctionCode",
          "lambda:UpdateFunctionConfiguration"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "7f9fb865-a1d1-48a0-8a31-5b87761159bf"
  }
}

resource "aws_iam_role" "privesc17-EditExistingLambdaFunctionWithRole-role" {
  name = "privesc17-EditExistingLambdaFunctionWithRole-role"
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
    yor_trace = "f6bf0d62-3c92-4f85-9005-23feb01522b9"
  }
}

resource "aws_iam_user" "privesc17-EditExistingLambdaFunctionWithRole-user" {
  name = "privesc17-EditExistingLambdaFunctionWithRole-user"
  path = "/"
  tags = {
    yor_trace = "b104277e-8639-4d06-9ced-92b36ba4cdae"
  }
}

resource "aws_iam_access_key" "privesc17-EditExistingLambdaFunctionWithRole-user" {
  user = aws_iam_user.privesc17-EditExistingLambdaFunctionWithRole-user.name
}


resource "aws_iam_user_policy_attachment" "privesc17-EditExistingLambdaFunctionWithRole-user-attach-policy" {
  user       = aws_iam_user.privesc17-EditExistingLambdaFunctionWithRole-user.name
  policy_arn = aws_iam_policy.privesc17-EditExistingLambdaFunctionWithRole.arn
}

resource "aws_iam_role_policy_attachment" "privesc17-EditExistingLambdaFunctionWithRole-role-attach-policy" {
  role       = aws_iam_role.privesc17-EditExistingLambdaFunctionWithRole-role.name
  policy_arn = aws_iam_policy.privesc17-EditExistingLambdaFunctionWithRole.arn
}
