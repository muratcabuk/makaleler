variable "name" {
  type    = string
  default = "Murat"
}

variable "age" {
  type    = number
  default = 30
}

output "greeting" {
  value = "Hello, my name is ${var.name} and I am ${var.age} years old."
}
