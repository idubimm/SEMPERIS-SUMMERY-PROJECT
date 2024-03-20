terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "github" {
    token = "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"  
}

resource "github_repository" "terraform-ex" {
    name = "terraform-example"
    description = "My first repository via terraform"
    visibility = "public"
}
