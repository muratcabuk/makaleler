variable "user" {
  type = object({
    name  = string
    email = string
    age   = number
  })
  default = {
    name  = "Alice"
    email = "alice@example.com"
    age   = 28
  }
}

output "user_info" {
  value = "Name: ${var.user.name}, Email: ${var.user.email}, Age: ${var.user.age}"
}
