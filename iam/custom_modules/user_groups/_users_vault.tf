resource "aws_iam_user" "vault_aws" {
  provider = aws.master

  force_destroy = "false"
  name          = "vault_aws"
  path          = "/"
}

resource "aws_iam_access_key" "vault_aws" {
  provider = aws.master
  user     = aws_iam_user.vault_aws.name
}

resource "aws_iam_policy" "vault_aws" {
  provider = aws.master

  name = "VaultAWS"
  path = "/"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:AttachUserPolicy",
        "iam:CreateAccessKey",
        "iam:CreateUser",
        "iam:DeleteAccessKey",
        "iam:DeleteUser",
        "iam:DeleteUserPolicy",
        "iam:DetachUserPolicy",
        "iam:ListAccessKeys",
        "iam:ListAttachedUserPolicies",
        "iam:ListGroupsForUser",
        "iam:ListUserPolicies",
        "iam:PutUserPolicy",
        "iam:AddUserToGroup",
        "iam:RemoveUserFromGroup"
      ],
      "Resource": ["arn:aws:iam::${local.master_account_id}:user/vault-*"]
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "vault_aws" {
  provider = aws.master

  name       = "vault_aws"
  policy_arn = aws_iam_policy.vault_aws.arn
  users      = [aws_iam_user.vault_aws.name]
}

resource "aws_iam_role" "vault_admin" {
  provider = aws.master

  name                 = "vault_admin"
  max_session_duration = 28800
  assume_role_policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_user.vault_aws.arn}"
      }
    }
  ]
}
EOF

  tags = merge(local.global_tags, {
    Name = "vault_admin"
  })
}

data "aws_iam_policy" "vault_admin" {
  provider = aws.master
  arn      = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data "aws_iam_policy" "cross_account_vault_admin" {
  provider = aws.master
  arn      = "arn:aws:iam::${local.master_account_id}:policy/CrossAccountAccess"
}

resource "aws_iam_role_policy_attachment" "vault_admin" {
  provider = aws.master

  role       = aws_iam_role.vault_admin.name
  policy_arn = data.aws_iam_policy.vault_admin.arn
}

resource "aws_iam_role_policy_attachment" "cross_account_admin" {
  provider = aws.master

  role       = aws_iam_role.vault_admin.name
  policy_arn = data.aws_iam_policy.cross_account_vault_admin.arn
}
