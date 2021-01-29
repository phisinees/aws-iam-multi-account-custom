resource "aws_iam_role" "vpc_flow_log" {
  name               = "VpcFlowLog"
  assume_role_policy = data.aws_iam_policy_document.assume_flow_log_role.json
}

resource "aws_iam_policy" "vpc_flow_log" {
  name   = "VpcFlowLog"
  policy = data.aws_iam_policy_document.vpc_flow_log.json
}

data "aws_iam_policy_document" "vpc_flow_log" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]
  }
}

resource "aws_iam_role_policy_attachment" "vpc_flow_log" {
  policy_arn = aws_iam_policy.vpc_flow_log.arn
  role       = aws_iam_role.vpc_flow_log.name
}

data "aws_iam_policy_document" "assume_flow_log_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}
