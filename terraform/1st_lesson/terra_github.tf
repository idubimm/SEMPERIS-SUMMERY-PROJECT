terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "github" {
    token = env.github.token 
}

resource "github_repository" "terraform-ex" {
    name = "terraform-example"
    description = "My first repository via terraform"
    visibility = "public"
}
