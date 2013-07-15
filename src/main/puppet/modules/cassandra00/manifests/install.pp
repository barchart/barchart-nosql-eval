#
#
#
class cassandra00::install (

    $package_name = $params::package_name,
    $config_path = $params::config_path,
    $topology_properties = $params::topology_properties,
    
  ) {

    notify { "DSE ${package_name}": }
      
    package { $package_name :
      ensure => installed,
    }
    
    # PropertiesSnitch
    file { "${config_path}/cassandra-topology.properties" :
      content => $topology_properties,
    }    
    
}
