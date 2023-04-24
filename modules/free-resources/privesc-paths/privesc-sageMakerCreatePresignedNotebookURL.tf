resource "aws_iam_policy" "privesc-sageMakerCreatePresignedNotebookURL-policy" {
  name        = "privesc-sageMakerCreatePresignedNotebookURL-policy"
  path        = "/"
  description = "Allows privesc via sagemakerCreatePresignedNotebookURL"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sagemaker:CreatePresignedNotebookInstanceUrl",
          "sagemaker:ListNotebookInstances"
        ]
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "d5ef589f-f374-4253-a044-2e67f768f728"
  }
}



resource "aws_iam_role" "privesc-sageMakerCreatePresignedNotebookURL-role" {
  name = "privesc-sageMakerCreatePresignedNotebookURL-role"
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
    yor_trace = "780c68ae-67f9-4d99-93d2-8f228542c03d"
  }
}


resource "aws_iam_user" "privesc-sageMakerCreatePresignedNotebookURL-user" {
  name = "privesc-sageMakerCreatePresignedNotebookURL-user"
  path = "/"
  tags = {
    yor_trace = "f9caf43c-5f7b-40f2-a2a4-f028ea88035e"
  }
}

resource "aws_iam_access_key" "privesc-sageMakerCreatePresignedNotebookURL-user" {
  user = aws_iam_user.privesc-sageMakerCreatePresignedNotebookURL-user.name
}



resource "aws_iam_user_policy_attachment" "privesc-sageMakerCreatePresignedNotebookURL-user-attach-policy" {
  user       = aws_iam_user.privesc-sageMakerCreatePresignedNotebookURL-user.name
  policy_arn = aws_iam_policy.privesc-sageMakerCreatePresignedNotebookURL-policy.arn
}


resource "aws_iam_role_policy_attachment" "privesc-sageMakerCreatePresignedNotebookURL-role-attach-policy" {
  role       = aws_iam_role.privesc-sageMakerCreatePresignedNotebookURL-role.name
  policy_arn = aws_iam_policy.privesc-sageMakerCreatePresignedNotebookURL-policy.arn

}

