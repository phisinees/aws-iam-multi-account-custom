resource "aws_iam_role" "readonly" {
  provider = aws.training

  name                 = "ReadOnly"
  description          = "Allows user to awsume read only's services"
  assume_role_policy   = data.aws_iam_policy_document.assume_from_master_account.json
  max_session_duration = 3600

  tags = merge(local.global_tags, {
    Name = "ReadOnly"
  })
}

resource "aws_iam_role_policy_attachment" "readonly_s3" {
  provider   = aws.training
  role       = aws_iam_role.readonly.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "readonly_ssm" {
  provider   = aws.training
  role       = aws_iam_role.readonly.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_role_policy_attachment" "readonly_iam_change_password" {
  provider   = aws.training
  role       = aws_iam_role.readonly.name
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

resource "aws_iam_role_policy_attachment" "readonly_support_access" {
  provider   = aws.training
  role       = aws_iam_role.readonly.name
  policy_arn = "arn:aws:iam::aws:policy/AWSSupportAccess"
}

resource "aws_iam_role_policy_attachment" "readonly" {
  provider   = aws.training
  role       = aws_iam_role.readonly.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "developer_sqs" {
  provider   = aws.training
  role       = aws_iam_role.readonly.name
  policy_arn = aws_iam_policy.developer_sqs.arn
}
