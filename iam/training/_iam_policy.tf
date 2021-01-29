resource "aws_iam_policy" "bi_lambda" {
  provider = aws.training

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

resource "aws_iam_policy" "developer_sqs" {
  provider = aws.training

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
      "Resource": "arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:key/*"
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
        "arn:aws:sqs:*:xxx:*"
      ]
    }
  ]
}
POLICY
}
