#
#
#
class cassandra_00::opsc::master  (

  ) {

    include params
    include packages
    include secrets

    $cluster_name   = $params::cluster_name
    $opscenter_host = $params::opscenter_host
     
    $jmx_port = $params::jmx_port
    $rpc_port = $params::rpc_port 
    $seeds    = $params::seeds
    
    $ssl_keyfile  = $secrets::ssl_keyfile
    $ssl_certfile = $secrets::ssl_certfile

    #
            
    $java_home_sh = "/etc/profile.d/java-home.sh"
    
    $master_etc            = "/etc/opscenter"
    $master_config         = "${master_etc}/opscenterd.conf"
    $master_clusters       = "${master_etc}/clusters"
    $master_clusters_entry = "${$master_clusters}/${cluster_name}.conf"

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
        subscribe => File[ 
          "${master_config}", 
          "${master_clusters_entry}",
          "${master_default}",
          "${java_home_sh}"
        ],
    }
              
}
