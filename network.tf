
# Network
resource "openstack_networking_network_v2" "faasd-internal-net" {
  name = "${local.name_prefix}-internal-net"

  # value_specs    = "${map("provider:network_type","vlan")}"
  admin_state_up = "true"
}

# Subnetworks
resource "openstack_networking_subnet_v2" "faasd-internal-subnet" {
  name            = "${local.name_prefix}-internal-subnet"
  network_id      = openstack_networking_network_v2.faasd-internal-net.id
  cidr            = "10.0.0.0/24"
  ip_version      = 4
  dns_nameservers = var.dns_nameservers
}

resource "openstack_networking_router_v2" "faasd-CUDN-Private" {
  name                = "${local.name_prefix}-CUDN-Private"
  admin_state_up      = "true"
  external_network_id = var.public_network
}

resource "openstack_networking_router_interface_v2" "faasd-CUDN-Private" {
  router_id  = openstack_networking_router_v2.faasd-CUDN-Private.id
  subnet_id  = openstack_networking_subnet_v2.faasd-internal-subnet.id
  depends_on = [openstack_networking_router_v2.faasd-CUDN-Private]
}

resource "openstack_networking_secgroup_v2" "faasd-sec-grp" {
  name        = "${local.name_prefix}-faasd-sec-grp"
  description = "faasd security group"
}

resource "openstack_networking_secgroup_rule_v2" "faasd_https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.faasd-sec-grp.id
}

resource "openstack_networking_secgroup_rule_v2" "faasd_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.faasd-sec-grp.id
}

resource "openstack_networking_secgroup_rule_v2" "faasd_icmp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  security_group_id = openstack_networking_secgroup_v2.faasd-sec-grp.id
}