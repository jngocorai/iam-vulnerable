resource "aws_iam_policy" "privesc-sageMakerCreateNotebookPassRole-policy" {
  name        = "privesc-sageMakerCreateNotebookPassRole-policy"
  path        = "/"
  description = "Allows privesc via sagemakerCreateNotebook"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sagemaker:CreateNotebookInstance",
          "sagemaker:CreatePresignedNotebookInstanceUrl",
          "sagemaker:ListNotebookInstances",
          "sagemaker:DescribeNotebookInstance",
          "sagemaker:StopNotebookInstance",
          "sagemaker:DeleteNotebookInstance",
          "iam:PassRole",
          "iam:ListRoles"
        ]
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "eb356ae0-ae4e-46ae-a5fb-917f0b49e6da"
  }
}



resource "aws_iam_role" "privesc-sageMakerCreateNotebookPassRole-role" {
  name = "privesc-sageMakerCreateNotebookPassRole-role"
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
    yor_trace = "15f392ae-5ede-4d6c-8862-1ad8f4fe7918"
  }
}


resource "aws_iam_user" "privesc-sageMakerCreateNotebookPassRole-user" {
  name = "privesc-sageMakerCreateNotebookPassRole-user"
  path = "/"
  tags = {
    yor_trace = "578240da-324d-4258-b402-b1eb9e1b63ea"
  }
}

resource "aws_iam_access_key" "privesc-sageMakerCreateNotebookPassRole-user" {
  user = aws_iam_user.privesc-sageMakerCreateNotebookPassRole-user.name
}



resource "aws_iam_user_policy_attachment" "privesc-sageMakerCreateNotebookPassRole-user-attach-policy" {
  user       = aws_iam_user.privesc-sageMakerCreateNotebookPassRole-user.name
  policy_arn = aws_iam_policy.privesc-sageMakerCreateNotebookPassRole-policy.arn
}


resource "aws_iam_role_policy_attachment" "privesc-sageMakerCreateNotebookPassRole-role-attach-policy" {
  role       = aws_iam_role.privesc-sageMakerCreateNotebookPassRole-role.name
  policy_arn = aws_iam_policy.privesc-sageMakerCreateNotebookPassRole-policy.arn

}

