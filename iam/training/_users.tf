module "users" {
  providers = {
    aws = aws.training
  }

  for_each = var.users

  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "3.3.0"

  create_iam_access_key         = false
  create_iam_user_login_profile = false
  force_destroy                 = true

  name = each.key
  tags = each.value.tags
}
