module "greet_user" {
  # ./modules/greet_user/main.tf
  source = "./modules/greet_user"
  name = "Murat"
}

output "greeting_message" {
  value = module.greet_user.greeting
}
