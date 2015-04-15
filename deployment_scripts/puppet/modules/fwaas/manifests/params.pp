class fwaas::params {

  if ($::osfamily == 'RedHat') {
    $server_service     = 'neutron-server'

    $l3_agent_service   = 'neutron-l3-agent'

    $dashboard_service  = 'httpd'
    $dashboard_settings = '/etc/openstack-dashboard/local_settings'
  } else {
    fail("Unsopported osfamily ${::osfamily}")
  }

}
