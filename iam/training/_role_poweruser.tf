module "power_user_iam_assumable_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 3.0"

  trusted_role_arns = [
    "arn:aws:iam::xxx:root",
  ]

  create_role = true

  role_name         = "PowerUser"
  role_requires_mfa = true

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/PowerUserAccess"
  ]

  number_of_custom_role_policy_arns = 1

  providers = {
    aws = aws.training
  }

  tags = merge(local.global_tags, {
    Name = "PowerUser"
  })
}
