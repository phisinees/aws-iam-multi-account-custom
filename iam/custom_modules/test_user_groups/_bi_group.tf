resource "aws_iam_group" "bi_group" {
  name = "BI_test"
}

resource "aws_iam_group_membership" "bi_group" {
  group = aws_iam_group.bi_group.name
  name  = "BI_test"

  users = [
    "${aws_iam_user.training.name}",
  ]
}

resource "aws_iam_group_policy_attachment" "bi_group" {
  group      = aws_iam_group.bi_group.name
  policy_arn = aws_iam_policy.bi_group.arn
}

resource "aws_iam_policy" "bi_group" {
  name   = "bi_group_policy"
  policy = data.aws_iam_policy_document.bi_group.json
}

data "aws_iam_policy_document" "bi_group" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    resources = [
      "arn:aws:iam::${local.training_account_id}:role/custom",
    ]
  }
}
