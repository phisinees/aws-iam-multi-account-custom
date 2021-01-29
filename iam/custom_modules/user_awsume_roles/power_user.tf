resource "aws_iam_role" "power_user" {
  name               = "PowerUser"
  assume_role_policy = data.aws_iam_policy_document.assume_from_master_account.json
}

resource "aws_iam_role_policy_attachment" "power_user_power_user" {
  role       = aws_iam_role.power_user.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_role_policy_attachment" "power_user_read_only" {
  role       = aws_iam_role.power_user.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
