# data "vault_aws_access_credentials" "creds" {
#   backend = "aws"
#   role    = "aws-admin-role"
#   type    = "sts"
# }

data "aws_caller_identity" "current" {
    provider = aws.training
}

data "aws_iam_policy_document" "assume_from_master_account" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }

    condition {
      test     = "NumericLessThan"
      variable = "aws:MultiFactorAuthAge"
      values   = [var.mfa_age]
    }

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.master_account_id}:root"]
    }
  }
}
