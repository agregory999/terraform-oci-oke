provider "oci" {
  fingerprint          = var.api_fingerprint
  private_key_path     = var.api_private_key_path
  private_key          = var.api_private_key
  region               = var.region
  tenancy_ocid         = var.tenancy_id
  user_ocid            = var.user_id
}

provider "oci" {
  fingerprint          = var.api_fingerprint
  private_key_path     = var.api_private_key_path
  private_key          = var.api_private_key
  region               = "us-ashburn-1"
  tenancy_ocid         = var.tenancy_id
  user_ocid            = var.user_id
  alias                = "home"
}