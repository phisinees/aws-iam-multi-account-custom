resource "aws_iam_role" "read_only" {
  name               = "ReadOnly"
  assume_role_policy = data.aws_iam_policy_document.assume_from_master_account.json
}

resource "aws_iam_role_policy_attachment" "read_only" {
  role       = aws_iam_role.read_only.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "s3" {
  role       = aws_iam_role.read_only.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
