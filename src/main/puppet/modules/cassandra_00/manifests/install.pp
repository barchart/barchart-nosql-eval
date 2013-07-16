#
#
#
class cassandra_00::install (

    $package_name = $params::package_name,
    $config_path = $params::config_path,
    $topology_properties = $params::topology_properties,
    
    $include_repo               = $params::include_repo,
    $repo_name                  = $params::repo_name,
    $repo_baseurl               = $params::repo_baseurl,
    $repo_gpgkey                = $params::repo_gpgkey,
    $repo_repos                 = $params::repo_repos,
    $repo_release               = $params::repo_release,
    $repo_pin                   = $params::repo_pin,
    $repo_gpgcheck              = $params::repo_gpgcheck,
    $repo_enabled               = $params::repo_enabled,
    
  ) inherits params {

    notify { "DSE ${package_name}": }
      
    package { $package_name :
      ensure => installed,
    }
    
    # PropertiesSnitch
    file { "${config_path}/cassandra-topology.properties" :
      content => $topology_properties,
    }    

    if($include_repo) {
        class { 'repo':
            repo_name => $repo_name,
            baseurl   => $repo_baseurl,
            gpgkey    => $repo_gpgkey,
            repos     => $repo_repos,
            release   => $repo_release,
            pin       => $repo_pin,
            gpgcheck  => $repo_gpgcheck,
            enabled   => $repo_enabled,
        }
    }
    
}
