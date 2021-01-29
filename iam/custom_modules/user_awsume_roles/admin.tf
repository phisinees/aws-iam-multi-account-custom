resource "aws_iam_role" "administrator" {
  name               = "AdminUser"
  assume_role_policy = data.aws_iam_policy_document.assume_from_master_account.json
}

resource "aws_iam_role_policy_attachment" "administrator" {
  role       = aws_iam_role.administrator.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
