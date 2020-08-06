resource "local_file" "cloud-init" {
  content = templatefile("templates/cloud-config.tmpl", {
    containerd_version = var.containerd_version
    caddy_version      = var.caddy_version
    faasd_version      = var.faasd_version
    letsencrypt_email  = var.letsencrypt_email
    gw_password        = random_password.password.result
    public_url         = var.public_url
    ssh_key = openstack_compute_keypair_v2.faasd_keypair.id

    }
  )
  filename = "${path.module}/cloud-init"
}
