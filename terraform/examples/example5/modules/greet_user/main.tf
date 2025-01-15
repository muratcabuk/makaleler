variable "name" {
  type    = string
  default = "Ahmet"
}

output "greeting" {
  value = "Hello, ${var.name}!"
}
