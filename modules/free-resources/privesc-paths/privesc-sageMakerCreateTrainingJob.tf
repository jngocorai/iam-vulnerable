resource "aws_iam_policy" "privesc-sageMakerCreateTrainingJobPassRole-policy" {
  name        = "privesc-sageMakerCreateTrainingJobPassRole-policy"
  path        = "/"
  description = "Allows privesc via sagemakerCreateTraining"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sagemaker:CreateTrainingJob",
          "iam:PassRole"
        ]
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "6ff123a9-3533-45a2-92c7-2f628d66dd31"
  }
}



resource "aws_iam_role" "privesc-sageMakerCreateTrainingJobPassRole-role" {
  name = "privesc-sageMakerCreateTrainingJobPassRole-role"
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
    yor_trace = "5d21cc17-7087-4dbe-916e-a5858b60f735"
  }
}


resource "aws_iam_user" "privesc-sageMakerCreateTrainingJobPassRole-user" {
  name = "privesc-sageMakerCreateTrainingJobPassRole-user"
  path = "/"
  tags = {
    yor_trace = "12bf7e29-aeb7-4f6c-8edd-018ea8a35499"
  }
}

resource "aws_iam_access_key" "privesc-sageMakerCreateTrainingJobPassRole-user" {
  user = aws_iam_user.privesc-sageMakerCreateTrainingJobPassRole-user.name
}



resource "aws_iam_user_policy_attachment" "privesc-sageMakerCreateTrainingJobPassRole-user-attach-policy" {
  user       = aws_iam_user.privesc-sageMakerCreateTrainingJobPassRole-user.name
  policy_arn = aws_iam_policy.privesc-sageMakerCreateTrainingJobPassRole-policy.arn
}


resource "aws_iam_role_policy_attachment" "privesc-sageMakerCreateTrainingJobPassRole-role-attach-policy" {
  role       = aws_iam_role.privesc-sageMakerCreateTrainingJobPassRole-role.name
  policy_arn = aws_iam_policy.privesc-sageMakerCreateTrainingJobPassRole-policy.arn

}

