resource "aws_iam_group" "admin_group" {
  name                              = "Admin"
  attach_iam_self_management_policy = true
}

resource "aws_iam_group_membership" "admin_group" {
  group = aws_iam_group.admin_group.name
  name  = "Admin"

  users = [
    aws_iam_user.phisinee_s.name,
    aws_iam_user.sven.name,
  ]
}

resource "aws_iam_group_policy_attachment" "admin_group" {
  group      = aws_iam_group.admin_group.name
  policy_arn = aws_iam_policy.admin_group.arn
}

resource "aws_iam_policy" "admin_group" {
  name   = "AdminGroupPolicy"
  policy = data.aws_iam_policy_document.topup_developers.json
}

data "aws_iam_policy_document" "admin_group" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    resources = [
      "arn:aws:iam::${local.staging_account_id}:role/AdminUser",
      "arn:aws:iam::${local.production_account_id}:role/AdminUser",
      "arn:aws:iam::${local.pre-production_account_id}:role/AdminUser",
      "arn:aws:iam::${local.training_account_id}:role/AdminUser",
    ]
  }
}
