resource "aws_iam_user" "training" {
  name          = "training"
  force_destroy = true
}
