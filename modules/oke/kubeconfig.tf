# Copyright 2017, 2021 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

locals {
  generate_kubeconfig_template = templatefile("${path.module}/scripts/generate_kubeconfig.template.sh",
    {
      cluster-id = oci_containerengine_cluster.k8s_cluster.id
      region     = var.region
    }
  )

  token_helper_template = templatefile("${path.module}/scripts/token_helper.template.sh",
    {
      cluster-id = oci_containerengine_cluster.k8s_cluster.id
      region     = var.region
    }
  )

  set_credentials_template = templatefile("${path.module}/scripts/kubeconfig_set_credentials.template.sh",
    {
      cluster-id    = oci_containerengine_cluster.k8s_cluster.id
      cluster-id-11 = substr(oci_containerengine_cluster.k8s_cluster.id, (length(oci_containerengine_cluster.k8s_cluster.id) - 11), length(oci_containerengine_cluster.k8s_cluster.id))
      region        = var.region
    }
  )
}

data "oci_containerengine_cluster_kube_config" "kube_config" {
  cluster_id = oci_containerengine_cluster.k8s_cluster.id
}

resource "null_resource" "create_local_kubeconfig" {
  provisioner "local-exec" {
    command = "rm -rf generated"
  }

  provisioner "local-exec" {
    command = "mkdir -p generated"
  }

  provisioner "local-exec" {
    command = "touch generated/kubeconfig"
  }
}

resource "local_file" "kube_config_file" {
  content         = data.oci_containerengine_cluster_kube_config.kube_config.content
  depends_on      = [null_resource.create_local_kubeconfig, oci_containerengine_cluster.k8s_cluster]
  filename        = "${path.root}/generated/kubeconfig"
  file_permission = "0600"
}

resource "null_resource" "write_kubeconfig_on_operator" {
  connection {
    host        = var.operator_private_ip
    private_key = var.ssh_private_key != "" ? var.ssh_private_key : file(var.ssh_private_key_path)
    timeout     = "40m"
    type        = "ssh"
    user        = "opc"

    bastion_host        = var.bastion_public_ip
    bastion_user        = "opc"
    bastion_private_key = var.ssh_private_key != "" ? var.ssh_private_key : file(var.ssh_private_key_path)
  }

  depends_on = [oci_containerengine_cluster.k8s_cluster, null_resource.install_kubectl_operator]

  provisioner "file" {
    content     = local.generate_kubeconfig_template
    destination = "~/generate_kubeconfig.sh"
  }

  provisioner "file" {
    content     = local.token_helper_template
    destination = "~/token_helper.sh"
  }

  provisioner "file" {
    content     = local.set_credentials_template
    destination = "~/kubeconfig_set_credentials.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x $HOME/generate_kubeconfig.sh",
      "$HOME/generate_kubeconfig.sh",
      "chmod +x $HOME/token_helper.sh",
      "sudo mv $HOME/token_helper.sh /usr/local/bin",
      "chmod +x $HOME/kubeconfig_set_credentials.sh",
      "$HOME/kubeconfig_set_credentials.sh",
      "rm -f $HOME/generate_kubeconfig.sh",
      "rm -f $HOME/kubeconfig_set_credentials.sh"
    ]
  }

  count = local.post_provisioning_ops == true ? 1 : 0
}
