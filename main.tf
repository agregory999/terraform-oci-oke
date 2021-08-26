# Copyright 2017, 2021 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

# cluster creation for oke
module "oke" {
  source = "./modules/oke"

  # provider
  tenancy_id = var.tenancy_id

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix

  # region parameters
  region = var.region

  # ssh keys
  ssh_private_key = var.ssh_private_key
  ssh_private_key_path = var.ssh_private_key_path
  ssh_public_key_path  = var.ssh_public_key_path
  ssh_public_key = var.ssh_public_key

  # bastion and operator details
  #bastion_public_ip           = local.bastion_public_ip
  bastion_public_ip           = var.bastion_public_ip
  #operator_private_ip         = local.operator_private_ip
  operator_private_ip         = var.operator_private_ip
  create_bastion_host         = var.create_bastion_host
  create_operator             = var.create_operator
  operator_instance_principal = var.operator_instance_principal
  operator_os_version         = var.operator_os_version
  bastion_state               = var.bastion_state

  # oke cluster parameters
  cluster_kubernetes_version                              = var.kubernetes_version
  control_plane_access                                    = var.control_plane_access
  cluster_name                                            = var.cluster_name
  cluster_options_add_ons_is_kubernetes_dashboard_enabled = var.dashboard_enabled
  cluster_options_kubernetes_network_config_pods_cidr     = var.pods_cidr
  cluster_options_kubernetes_network_config_services_cidr = var.services_cidr
#  cluster_subnets                                         = module.network.subnet_ids
  cluster_subnets                                         = var.cluster_subnets
#  vcn_id                                                  = module.vcn.vcn_id
  vcn_id                                                  = var.vcn_id
  use_encryption                                          = var.use_encryption
  kms_key_id                                              = var.kms_key_id
  use_signed_images                                       = var.use_signed_images
  image_signing_keys                                      = var.image_signing_keys
  admission_controller_options                            = var.admission_controller_options

  # oke node pool parameters
  node_pools            = var.node_pools
  node_pool_name_prefix = var.node_pool_name_prefix
  node_pool_image_id    = var.node_pool_image_id
  node_pool_os          = var.node_pool_os
  node_pool_os_version  = var.node_pool_os_version

  # oke load balancer parameters
  preferred_lb_type = var.preferred_lb_type

  # ocir parameters
  email_address    = var.email_address
  ocir_urls        = var.ocir_urls
  secret_id        = var.secret_id
  secret_name      = var.secret_name
  secret_namespace = var.secret_namespace
  username         = var.username

  # calico parameters
  calico_version = var.calico_version
  install_calico = var.enable_calico

  # metric server
  enable_metric_server = var.enable_metric_server
  enable_vpa           = var.enable_vpa
  vpa_version          = var.vpa_version

  # service account
  create_service_account               = var.create_service_account
  service_account_name                 = var.service_account_name
  service_account_namespace            = var.service_account_namespace
  service_account_cluster_role_binding = var.service_account_cluster_role_binding

  #check worker nodes are active
  check_node_active = var.check_node_active

  nodepool_drain = var.nodepool_drain

  nodepool_upgrade_method = var.nodepool_upgrade_method

  node_pools_to_drain = var.node_pools_to_drain

}
