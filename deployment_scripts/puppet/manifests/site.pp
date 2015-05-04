$fuel_settings = parseyaml($astute_settings_yaml)

if $fuel_settings {
  class { 'fwaas':
    cluster_mode => $fuel_settings['deployment_mode'],
  }
}
