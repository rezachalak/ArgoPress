// get the remote state data for eks
data "terraform_remote_state" "eks" {
  backend = "s3"

  config = {
    bucket               = "argopress-demo.tfstate"
    key                  = "argocdinfra.json"
    region               = "eu-west-1"
    workspace_key_prefix = "environment"
    dynamodb_table       = "argopress-demo.tfstate.lock"
  }
}
