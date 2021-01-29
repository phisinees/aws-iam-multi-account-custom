resource "aws_iam_account_password_policy" "password-policy" {
  provider = aws.master

  minimum_password_length        = 22
  max_password_age               = 90
  password_reuse_prevention      = 24
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
}
