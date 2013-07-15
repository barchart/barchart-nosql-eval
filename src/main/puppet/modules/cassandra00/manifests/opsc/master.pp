#
#
#
class cassandra00::opsc::master  (

  $cluster_name   = $params::cluster_name,
  $opscenter_host = $params::opscenter_host,
   
  $jmx_port = $params::jmx_port, 
  $rpc_port = $params::rpc_port, 
  $seeds    = $params::seeds, 
      
  ) {

    include packages

    # Enable master service.    
    service { 'opscenterd' :
        enable   => true,
        ensure  => running,
        require => Package['opscenter'],
    }
    
    $master_etc     = "/etc/opscenter"
    $master_conf    = "${master_etc}/opscenterd.conf"
    $master_cluster = "${master_etc}/clusters/${cluster_name}"

    file { "${master_conf}":
        ensure  => file,
        content  => template("${module_name}/opscenterd.conf.erb"),
        require => Service['opscenterd'],
    }
              
    file { "${master_cluster}":
        ensure  => file,
        content  => template("${module_name}/opscenterd.cluster.conf.erb"),
        require => Service['opscenterd'],
    }
              
}
