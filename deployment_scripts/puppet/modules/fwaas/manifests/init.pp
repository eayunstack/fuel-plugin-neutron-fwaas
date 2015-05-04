class fwaas (
  $fwaas_driver  = 'neutron.services.firewall.drivers.linux.iptables_fwaas.IptablesFwaasDriver',
  $fwaas_enabled = true,
  $fwaas_plugin  = 'neutron.services.firewall.fwaas_plugin.FirewallPlugin',
  $cluster_mode  = undef,
) {

  include fwaas::params

  service { $fwaas::params::l3_agent_service:
    ensure   => running,
    enable   => true,
    provider => $cluster_mode ? {
      'ha_compact' => 'pacemaker',
      default      => undef
    },
  }

  neutron_fwaas_config {
    'fwaas/driver':  value => $fwaas_driver;
    'fwaas/enabled': value => $fwaas_enabled;
  }

  Neutron_fwaas_config<||> ~> Service[$fwaas::params::l3_agent_service]

  service { $fwaas::params::server_service:
    ensure => running,
    enable => true,
  }

  neutron_config { 'DEFAULT/service_plugins':
    value          => $fwaas_plugin,
    append_to_list => true,
  }

  Neutron_config<||> ~> Service[$fwaas::params::server_service]

  service { $fwaas::params::dashboard_service:
    ensure => running,
    enable => true,
  }

  exec { "enable_fwaas_dashboard":
    command => "/bin/echo \"OPENSTACK_NEUTRON_NETWORK['enable_firewall'] = True\" >> $fwaas::params::dashboard_settings",
    unless  => "/bin/egrep \"^OPENSTACK_NEUTRON_NETWORK['enable_firewall'] = True\" $fwaas::params::dashboard_settings",
  }

  Exec['enable_fwaas_dashboard'] ~> Service[$fwaas::params::dashboard_service]

}
