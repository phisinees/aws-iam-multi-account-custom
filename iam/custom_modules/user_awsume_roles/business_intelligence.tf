resource "aws_iam_role" "business_intelligence" {
  name               = "Business_Intelligence"
  assume_role_policy = data.aws_iam_policy_document.assume_from_master_account.json
}

resource "aws_iam_role_policy_attachment" "s3_bi" {
  role       = aws_iam_role.business_intelligence.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.business_intelligence.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}

resource "aws_iam_role_policy_attachment" "sagemaker" {
  role       = aws_iam_role.business_intelligence.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

resource "aws_iam_role_policy_attachment" "ec2" {
  role       = aws_iam_role.business_intelligence.name
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceConnect"
}

resource "aws_iam_role_policy_attachment" "glue_console" {
  role       = aws_iam_role.business_intelligence.name
  policy_arn = "arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess"
}

resource "aws_iam_role_policy_attachment" "glue_service_notebook" {
  role       = aws_iam_role.business_intelligence.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceNotebookRole"
}

resource "aws_iam_role_policy_attachment" "personalize" {
  role       = aws_iam_role.business_intelligence.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonPersonalizeFullAccess"
}

resource "aws_iam_role_policy_attachment" "custom_lambda" {
  role       = aws_iam_role.business_intelligence.name
  policy_arn = aws_iam_policy.BI_Lambda.arn
}

resource "aws_iam_policy" "BI_Lambda" {
  name = "BI_Lambda"

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
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/Business_Intelligence"
      ]
    }
  ]
}
POLICY
}
