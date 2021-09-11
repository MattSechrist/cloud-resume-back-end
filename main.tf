terraform {
    backend "remote" {
        # The name of your Terraform Cloud organization.
        organization = "matthewsechrist"

        # The name of the Terraform Cloud workspace to store Terraform state files in.
        workspaces {
          name = "cloud_resume_back_end"
        }          
    }
}

# An example resource that does nothing.
resource "null_resource" "example" {
    triggers = {
        value = "A example resource that does nothing!"
    }
}