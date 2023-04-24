resource "aws_iam_policy" "privesc-AssumeRole-high-priv-policy" {
  name        = "privesc-AssumeRole-high-priv-policy"
  path        = "/"
  description = "Allows privesc via targeted sts:AssumeRole"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "*"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "06b30845-9a49-4919-aa8f-a788deb284e9"
  }
}

resource "aws_iam_role" "privesc-AssumeRole-starting-role" {
  name = "privesc-AssumeRole-starting-role"
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
    yor_trace = "8824fbba-0af1-4dda-9315-6a263b32b6ef"
  }
}

resource "aws_iam_role" "privesc-AssumeRole-intermediate-role" {
  name = "privesc-AssumeRole-intermediate-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = aws_iam_role.privesc-AssumeRole-starting-role.arn
        }
      },
    ]
  })
  tags = {
    yor_trace = "0c66ff53-a530-41d1-8086-f56f7b1f17bd"
  }
}


resource "aws_iam_role" "privesc-AssumeRole-ending-role" {
  name = "privesc-AssumeRole-ending-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = aws_iam_role.privesc-AssumeRole-intermediate-role.arn
        }
      },
    ]
  })
  tags = {
    yor_trace = "31010b3e-142e-47c4-b471-c832c2316fbe"
  }
}



resource "aws_iam_user" "privesc-AssumeRole-start-user" {
  name = "privesc-AssumeRole-start-user"
  path = "/"
  tags = {
    yor_trace = "896e5712-87d5-4dec-96e5-8448628dcdee"
  }
}
resource "aws_iam_access_key" "privesc-AssumeRole-start-user" {
  user = aws_iam_user.privesc-AssumeRole-start-user.name
}
resource "aws_iam_role_policy_attachment" "privesc-AssumeRole-high-priv-policy-role-attach-policy" {
  role       = aws_iam_role.privesc-AssumeRole-ending-role.name
  policy_arn = aws_iam_policy.privesc-AssumeRole-high-priv-policy.arn

}  