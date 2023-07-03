# Installation

With Terraform, direnv and Bitwarden CLI installed, run:

`aws-vault exec terraform-skladis --no-session -- terraform apply`

`--no-session` is required because AWS API restrictions, that won't allow you to touch IAM related APIs using the
account with MFA enabled, unless you pass the MFA token within the request (
see [this issue](https://github.com/99designs/aws-vault/issues/260)).