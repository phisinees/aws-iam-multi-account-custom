# module "user_awsume_roles" {
#   source = "../modules/user_awsume_roles"
#   provider = aws.training
# }

resource "aws_iam_role" "custom" {
  name                  = "custom"
  description           = "Allows Glue to call AWS services on your behalf. "
  path                  = "/"
  force_detach_policies = false
  max_session_duration  = 3600

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "glue.amazonaws.com",
          "sagemaker.amazonaws.com",
          "redshift.amazonaws.com",
          "personalize.amazonaws.com"
        ]
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "custom_rds" {
  role       = aws_iam_role.custom.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

resource "aws_iam_role_policy_attachment" "custom_redshift" {
  role       = aws_iam_role.custom.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRedshiftFullAccess"
}

resource "aws_iam_role_policy_attachment" "custom_sagemaker" {
  role       = aws_iam_role.custom.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

resource "aws_iam_role_policy_attachment" "custom_ec2_connect" {
  role       = aws_iam_role.custom.name
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceConnect"
}

resource "aws_iam_role_policy_attachment" "custom_ec2_ssm" {
  role       = aws_iam_role.custom.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "custom_glue_service" {
  role       = aws_iam_role.custom.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceNotebookRole"
}

resource "aws_iam_role_policy_attachment" "custom_glue_console" {
  role       = aws_iam_role.custom.name
  policy_arn = "arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess"
}

### will use this solution after this line ###

resource "aws_iam_role_policy_attachment" "custom_lambda" {
  role       = aws_iam_role.custom.name
  policy_arn = aws_iam_policy.custom_lambda.arn
}

resource "aws_iam_policy" "custom_lambda" {
  name = "custom_lambda"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "lambda:InvokeFunction",
        "lambda:UpdateFunctionCode"
      ],
      "Effect": "Allow",
      "Resource": ["*"]
    },
    {
      "Action": [
        "iam:PassRole"
      ],
      "Condition": {
        "StringLike": {
          "iam:PassedToService": [
            "glue.amazonaws.com"
          ]
        }
      },
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/custom", "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/temp"
      ]
    }
  ]
}
POLICY
}

module "iam_assumable_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 3.0"

  trusted_role_arns = [
    "arn:aws:iam::207606013102:root",
    # "arn:aws:iam::835367859851:user/anton",
  ]

  create_role = true

  role_name         = "temp"
  role_requires_mfa = true

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonCognitoReadOnly",
  ]

  number_of_custom_role_policy_arns = 1

  providers = {
    aws = aws.training
  }
}