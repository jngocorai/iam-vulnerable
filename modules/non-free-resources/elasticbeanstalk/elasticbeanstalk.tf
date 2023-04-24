resource "aws_elastic_beanstalk_application" "privesc-elasticbeanstalk-app" {
  name        = "privesc-elasticbeanstalk-app"
  description = "privesc-elasticbeanstalk-app"
  tags = {
    yor_trace = "6968a8de-f1d1-4bfb-bb1b-27d39cecf014"
  }
}

resource "aws_elastic_beanstalk_environment" "privesc-elasticbeanstalk-env" {
  name                = "privesc-elasticbeanstalk-env"
  application         = aws_elastic_beanstalk_application.privesc-elasticbeanstalk-app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.4.4 running Docker"
  instance_type       = "t2.micro"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = var.shared_high_priv_servicerole
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = var.shared_high_priv_servicerole
  }

  tags = {
    yor_trace = "9b8691ee-1898-4d49-aef4-06e606de4df0"
  }
}

resource "aws_elastic_beanstalk_application_version" "privesc-elasticbeanstalk-app-version" {
  name        = "privesc-elasticbeanstalk-app-version"
  application = aws_elastic_beanstalk_application.privesc-elasticbeanstalk-app.name
  bucket      = "my-test-bucket-for-ebs"
  key         = "latest.zip"
  tags = {
    yor_trace = "a1020a65-61c3-4044-affd-a3b7a18471fb"
  }
}