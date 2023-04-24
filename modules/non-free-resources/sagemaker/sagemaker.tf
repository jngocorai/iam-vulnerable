resource "aws_sagemaker_notebook_instance" "privesc-sagemakerNotebook" {
  name          = "privesc-sagemakerNotebook"
  role_arn      = aws_iam_role.privesc-sagemaker-role.arn
  instance_type = "ml.t2.medium"

  tags = {
    Name      = "foo"
    yor_trace = "0d170803-b8a9-4d12-8f65-226193ffeab2"
  }
}


resource "aws_iam_role" "privesc-sagemaker-role" {
  name               = "privesc-sagemaker-role"
  assume_role_policy = data.aws_iam_policy_document.example.json
  tags = {
    yor_trace = "f4df0f70-f3ba-43af-9d4d-fefb7cc7bca0"
  }
}

data "aws_iam_policy_document" "example" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["sagemaker.amazonaws.com"]
    }
  }
}


resource "aws_iam_policy" "privesc-high-priv-sagemaker-policy" {
  name        = "privesc-high-priv-sagemaker-policy2"
  path        = "/"
  description = "High priv policy used by sagemaker"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "*"
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "56076cd4-d2ce-4342-9495-930c721207d6"
  }
}


resource "aws_iam_role_policy_attachment" "example-AWSSagemakerServiceRole" {
  policy_arn = aws_iam_policy.privesc-high-priv-sagemaker-policy.arn
  role       = aws_iam_role.privesc-sagemaker-role.name
}