#
#
#
class cassandra_00::service (){

  include params
  include config
    
  service { $params::service_name :
      ensure     => running,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
      subscribe   => Class['config'],
      require    => Class['config'],
  }
    
}
