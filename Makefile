.PHONY: help

help:
	@echo "make {plan|apply|deploy|destroy}"

init:
	terraform init

plan: init
	terraform plan -out=faasd.plan -var-file variables.tfvars

apply:
	terraform apply -auto-approve -input=false "faasd.plan"

destroy:
	terraform destroy -var-file variables.tfvars -auto-approve