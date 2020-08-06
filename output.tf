
output "gateway_url" {
  value = "https://${var.public_url}/"
}

output "password" {
  value = random_password.password.result
}

output "login_cmd" {
  value = "faas-cli login -g https://${var.public_url}/ -p ${random_password.password.result}"
}
