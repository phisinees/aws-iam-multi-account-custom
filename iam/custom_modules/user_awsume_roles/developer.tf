resource "aws_iam_role" "developer" {
  name               = "Developer"
  assume_role_policy = data.aws_iam_policy_document.assume_from_master_account.json
}

resource "aws_iam_role_policy_attachment" "s3_developer" {
  role       = aws_iam_role.developer.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "readonly" {
  role       = aws_iam_role.developer.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "iam_change_password" {
  role       = aws_iam_role.developer.name
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.developer.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_role_policy_attachment" "aws_support" {
  role       = aws_iam_role.developer.name
  policy_arn = "arn:aws:iam::aws:policy/AWSSupportAccess"
}

resource "aws_iam_role_policy_attachment" "custom_sqs" {
  role       = aws_iam_role.developer.name
  policy_arn = aws_iam_policy.Developers_SQS.arn
}

resource "aws_iam_policy" "Developers_SQS" {
  name = "Developers_SQS"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "kms:GenerateDataKey",
        "kms:Decrypt"
      ],
      "Resource": "arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:key/038c5b9b-bbeb-4404-8cc5-2a24c2369c0c"
    },
    {
      "Effect": "Allow",
      "Action": [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes",
        "sqs:SendMessage",
        "sqs:SendMessageBatch",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:sqs:*:${data.aws_caller_identity.current.account_id}:*"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "custom_health" {
  role       = aws_iam_role.developer.name
  policy_arn = aws_iam_policy.custom_health.arn
}

resource "aws_iam_policy" "custom_health" {
  name = "Read-Only-Health"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
        "health:DescribeAffectedEntities",
        "health:DescribeEventDetailsForOrganization",
        "health:DescribeAffectedEntitiesForOrganization",
        "ssm:UpdateInstanceInformation",
        "health:DescribeEventAggregates",
        "health:DescribeEventDetails",
        "health:DescribeEventTypes",
        "health:DescribeAffectedAccountsForOrganization",
        "health:DescribeEventsForOrganization",
        "health:DescribeEvents",
        "health:DescribeEntityAggregates"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}
