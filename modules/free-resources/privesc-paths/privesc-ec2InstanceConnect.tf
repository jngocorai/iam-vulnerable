resource "aws_iam_policy" "privesc-ec2InstanceConnect-policy" {
  name        = "privesc-ec2InstanceConnect-policy"
  path        = "/"
  description = "Allows privesc via ec2-instance-connect send-public-key if the instance has a public IP, you have network access to ssh to the instance, and the instance supports instance-connect"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2-instance-connect:SendSSHPublicKey",
          "ec2-instance-connect:SendSerialConsoleSSHPublicKey",
        ]
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "065781e9-7759-49aa-9074-bf07c90bffd4"
  }
}



resource "aws_iam_role" "privesc-ec2InstanceConnect-role" {
  name = "privesc-ec2InstanceConnect-role"
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
    yor_trace = "13bc1b5e-d553-4a14-9088-45de847c4843"
  }
}


resource "aws_iam_user" "privesc-ec2InstanceConnect-user" {
  name = "privesc-ec2InstanceConnect-user"
  path = "/"
  tags = {
    yor_trace = "d7c265c6-2cc6-474f-9e76-fb4deb64c159"
  }
}

resource "aws_iam_access_key" "privesc-ec2InstanceConnect-user" {
  user = aws_iam_user.privesc-ec2InstanceConnect-user.name
}



resource "aws_iam_user_policy_attachment" "privesc-ec2InstanceConnect-user-attach-policy" {
  user       = aws_iam_user.privesc-ec2InstanceConnect-user.name
  policy_arn = aws_iam_policy.privesc-ec2InstanceConnect-policy.arn
}


resource "aws_iam_role_policy_attachment" "privesc-ec2InstanceConnect-role-attach-policy" {
  role       = aws_iam_role.privesc-ec2InstanceConnect-role.name
  policy_arn = aws_iam_policy.privesc-ec2InstanceConnect-policy.arn

}

