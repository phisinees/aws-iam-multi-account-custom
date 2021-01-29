module "iam_group_with_assumable_roles_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy"
  version = "~> 3.0"

  name  = "Read-Only"

  assumable_roles = [
    "arn:aws:iam::${local.training_account_id}:role/temp",
    "arn:aws:iam::${local.staging_account_id}:role/temp",
  ]
  
  group_users = [
    "temp",
    "custom"
  ]

  providers = {
    aws = aws.training
  }
}