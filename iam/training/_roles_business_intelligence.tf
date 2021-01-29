resource "aws_iam_role" "business_intelligence" {
  provider = aws.training

  name                 = "Business_Intelligence"
  description          = "Allows user to awsume business intelligence's services"
  assume_role_policy   = data.aws_iam_policy_document.assume_from_master_account.json
  max_session_duration = 3600

  tags = merge(local.global_tags, {
    Name = "Business_Intelligence"
  })
}

resource "aws_iam_role_policy_attachment" "business_intelligence_rds" {
  provider   = aws.training
  role       = aws_iam_role.business_intelligence.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

resource "aws_iam_role_policy_attachment" "business_intelligence_redshift" {
  provider   = aws.training
  role       = aws_iam_role.business_intelligence.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRedshiftFullAccess"
}

resource "aws_iam_role_policy_attachment" "business_intelligence_sagemaker" {
  provider   = aws.training
  role       = aws_iam_role.business_intelligence.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

resource "aws_iam_role_policy_attachment" "business_intelligence_ec2_connect" {
  provider   = aws.training
  role       = aws_iam_role.business_intelligence.name
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceConnect"
}

resource "aws_iam_role_policy_attachment" "business_intelligence_ec2_ssm" {
  provider   = aws.training
  role       = aws_iam_role.business_intelligence.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "business_intelligence_glue_service" {
  provider   = aws.training
  role       = aws_iam_role.business_intelligence.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceNotebookRole"
}

resource "aws_iam_role_policy_attachment" "business_intelligence_glue_console" {
  provider   = aws.training
  role       = aws_iam_role.business_intelligence.name
  policy_arn = "arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess"
}

resource "aws_iam_role_policy_attachment" "business_intelligence_bi_lambda" {
  provider   = aws.training
  role       = aws_iam_role.business_intelligence.name
  policy_arn = aws_iam_policy.bi_lambda.arn
}
