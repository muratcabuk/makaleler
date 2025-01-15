variable "numbers" {
  type    = list(number)
  default = [1, 2, 3, 4, 5]
}

output "doubled_numbers" {
  value = [for num in var.numbers : num * 2]
}
