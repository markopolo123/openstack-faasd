locals {
  name_prefix = "faasd"
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_-#"
}


resource "openstack_compute_keypair_v2" "faasd_keypair" {
  name = "faasd-keypair"
  # name       = "${replace("${local.key_name}","-","_")}_keypair"
  public_key = file(var.ssh_key_file)
}

resource "openstack_compute_instance_v2" "faasd" {
  depends_on          = [openstack_compute_keypair_v2.faasd_keypair, local_file.cloud-init]
  name                = "${local.name_prefix}-prod"
  image_name          = var.image_name
  flavor_name         = var.flavor_name
  key_pair            = openstack_compute_keypair_v2.faasd_keypair.name
  stop_before_destroy = true

  security_groups = [openstack_networking_secgroup_v2.faasd-sec-grp.name]

  network {
    name = openstack_networking_network_v2.faasd-internal-net.name
  }
  # Provisioning
  user_data = local_file.cloud-init.content

  lifecycle {
    create_before_destroy = false
  }
}

resource "openstack_compute_floatingip_associate_v2" "fip" {
  floating_ip = var.static_fip
  instance_id = openstack_compute_instance_v2.faasd.id
}