terraform {
  backend "remote" {
    organization = "andrewgregory"

    workspaces {
      name = "terraform-oci-oke-existing-vcn"
    }
  }
}
