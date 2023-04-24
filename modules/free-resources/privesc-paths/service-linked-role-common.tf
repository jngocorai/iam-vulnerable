# These file creates the policy, role, and instance profile required for privesc3-CreateEC2WithExistingInstanceProfile and privesc-ssm to work. 

resource "aws_iam_policy" "privesc-high-priv-service-policy" {
  name        = "privesc-high-priv-service-policy"
  path        = "/"
  description = "High priv policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
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
    yor_trace = "ec44040f-8f87-4054-9d8a-be4b0075a29b"
  }
}

data "aws_iam_policy" "AmazonSSMManagedInstanceCore" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role" "privesc-high-priv-service-role" {
  name = "privesc-high-priv-service-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = [
            "ec2.amazonaws.com",
            "datapipeline.amazonaws.com",
            "cloudformation.amazonaws.com",
            "lambda.amazonaws.com",
            "glue.amazonaws.com",
            "ecs-tasks.amazonaws.com",
            "codebuild.amazonaws.com",
            "eks.amazonaws.com",
            "sagemaker.amazonaws.com",
            "elasticbeanstalk.amazonaws.com"
          ]
        }
      },
    ]
  })
  tags = {
    yor_trace = "27d8cb1c-c596-4dee-89b1-3968089340cd"
  }
}

resource "aws_iam_instance_profile" "privesc-high-priv-service-policy_profile" {
  name = "privesc-high-priv-service-profile"
  role = aws_iam_role.privesc-high-priv-service-role.name
  tags = {
    yor_trace = "b861394e-c4fa-4938-919b-385d35e44914"
  }
}



resource "aws_iam_role_policy_attachment" "privesc-high-priv-service-role-attach-policy1" {
  role       = aws_iam_role.privesc-high-priv-service-role.name
  policy_arn = aws_iam_policy.privesc-high-priv-service-policy.arn

}
resource "aws_iam_role_policy_attachment" "privesc-high-priv-service-role-attach-policy2" {
  role       = aws_iam_role.privesc-high-priv-service-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"

}  