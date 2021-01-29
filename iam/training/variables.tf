# variable "approle_role_id" {
#   type = string
# }

# variable "approle_secret_id" {
#   type = string
# }

variable "users" {
  type = map(object({
    tags = object({
      email = string
    })
  }))
  description = "User list"
}