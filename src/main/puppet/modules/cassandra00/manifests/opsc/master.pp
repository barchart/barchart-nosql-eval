#
#
#
class cassandra00::opsc::master  (

  $cluster_name   = $params::cluster_name,
  $opscenter_host = $params::opscenter_host,
   
  $jmx_port = $params::jmx_port, 
  $rpc_port = $params::rpc_port, 
  $seeds    = $params::seeds, 

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
    
    include packages

    $java_home_sh = "/etc/profile.d/java-home.sh"
    
    $master_etc            = "/etc/opscenter"
    $master_config         = "${master_etc}/opscenterd.conf"
    $master_clusters       = "${master_etc}/clusters"
    $master_clusters_entry = "${$master_clusters}/${cluster_name}"

    file { [ "${master_etc}", "${$master_clusters}" ]:
        ensure  => directory,
    }

    file { "${master_config}":
        ensure  => file,
        content  => template("${module_name}/opscenterd.conf.erb"),
    }
              
    file { "${master_clusters_entry}":
        ensure  => file,
        content  => template("${module_name}/opscenterd.cluster.conf.erb"),
    }

    $etc_default = "/etc/default"
    $master_default = "${etc_default}/opscenterd"
    
    file { "${etc_default}" :
        ensure  => directory,
    }
    
    file { "${master_default}" :
        ensure  => file,
        content  => template("${module_name}/opscenterd.default.erb"),
        require => File["/etc/default"],
    }
    
    # Enable master service.    
    service { 'opscenterd' :
        enable   => true,
        ensure  => running,
        require => Package['opscenter'],
        subscribe   => File[ 
          "${master_config}", 
          "${master_clusters_entry}",
          "${master_default}",
          "${java_home_sh}",
        ],
    }
              
}
