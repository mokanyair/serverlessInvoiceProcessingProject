terraform {
  cloud {
    organization = "personal_projects_morganevipayee"

    workspaces {
      name = "invoice-processing"
    }
  }
}

#terraform {
#    required_version = ">=1.0"
#    backend "s3" {
#        bucket = "compliancce-archive-docs-airveepayee"
#        key = "cloudfron/dev/terraform.tfstate"
#        region = "us-east-1"
#    }
#}