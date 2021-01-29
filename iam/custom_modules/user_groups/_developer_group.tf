resource "aws_iam_group" "developer_group" {
  name                              = "Developer"
  attach_iam_self_management_policy = true
}

resource "aws_iam_group_membership" "developer_group" {
  group = aws_iam_group.developer_group.name
  name  = "Read_Only"

  users = [
    aws_iam_user.pom.name,
    aws_iam_user.michael_r.name,
    aws_iam_user.david.name,
    aws_iam_user.joe.name,
    aws_iam_user.not.name,
    aws_iam_user.suraj.name,
    aws_iam_user.xavier_g.name,
    aws_iam_user.toey.name,
    aws_iam_user.nivin.name,
    aws_iam_user.nop.name,
    aws_iam_user.suresh.name,
    aws_iam_user.ange.name,
    aws_iam_user.stock.name,
    aws_iam_user.bala.name,
    aws_iam_user.deeksha.name,
    aws_iam_user.kavi.name,
    aws_iam_user.vasinee.name,
    aws_iam_user.job.name,
    aws_iam_user.nichapa_d.name,
    aws_iam_user.pimchanok_w.name,
    aws_iam_user.daniel_g.name,
    aws_iam_user.imagix.name,
  ]
}

resource "aws_iam_group_policy_attachment" "developer_group" {
  group      = aws_iam_group.developer_group.name
  policy_arn = aws_iam_policy.developer_group.arn
}

resource "aws_iam_policy" "developer_group" {
  name   = "developer_group_policy"
  policy = data.aws_iam_policy_document.developer_group.json
}

data "aws_iam_policy_document" "developer_group" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    resources = [
      "arn:aws:iam::${local.staging_account_id}:role/ReadOnly",
      "arn:aws:iam::${local.production_account_id}:role/ReadOnly",
      "arn:aws:iam::${local.pre-production_account_id}:role/ReadOnly",
      "arn:aws:iam::${local.training_account_id}:role/ReadOnly",
      "arn:aws:iam::${local.staging_account_id}:role/Developer",
      "arn:aws:iam::${local.production_account_id}:role/Developer",
      "arn:aws:iam::${local.pre-production_account_id}:role/Developer",
      "arn:aws:iam::${local.training_account_id}:role/Developer",
    ]
  }
}
