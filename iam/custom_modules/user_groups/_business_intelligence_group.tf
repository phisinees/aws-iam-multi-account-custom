resource "aws_iam_group" "business_intelligence_group" {
  name                              = "Business_Intelligence"
  attach_iam_self_management_policy = true
}

resource "aws_iam_group_membership" "business_intelligence_group" {
  group = aws_iam_group.business_intelligence_group.name
  name  = "Business_Intelligence"

  users = [
    aws_iam_user.ange.name,
    aws_iam_user.stock.name,
    aws_iam_user.bala.name,
    aws_iam_user.deeksha.name,
    aws_iam_user.kavi.name,
    aws_iam_user.vasinee.name,
    aws_iam_user.job.name,
    aws_iam_user.nichapa_d.name,
    aws_iam_user.pimchanok_w.name,
  ]
}

resource "aws_iam_group_policy_attachment" "business_intelligence_group" {
  group      = aws_iam_group.business_intelligence_group.name
  policy_arn = aws_iam_policy.business_intelligence_group.arn
}

resource "aws_iam_policy" "business_intelligence_group" {
  name   = "business_intelligence_group_policy"
  policy = data.aws_iam_policy_document.bi_group.json
}

data "aws_iam_policy_document" "business_intelligence_group" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    resources = [
      "arn:aws:iam::${local.staging_account_id}:role/Business_Intelligence",
      "arn:aws:iam::${local.production_account_id}:role/Business_Intelligence",
      "arn:aws:iam::${local.pre-production_account_id}:role/Business_Intelligence",
      "arn:aws:iam::${local.training_account_id}:role/Business_Intelligence",
    ]
  }
}
