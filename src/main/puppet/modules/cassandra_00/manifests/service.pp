#
#
#
class cassandra_00::service (

    $service_name = $params::service_name,

  ){
    
    service { $service_name:
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        subscribe   => Class['config'],
        require    => Class['config'],
    }
    
}
