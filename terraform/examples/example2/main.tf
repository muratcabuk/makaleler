variable "is_admin" {
  type    = bool
  description = "Set to true if the user is an admin"
}

output "role" {
  value = var.is_admin ? "Admin" : "User"
}
