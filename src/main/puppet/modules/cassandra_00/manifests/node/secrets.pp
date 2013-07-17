#
#
#
class cassandra_00::node::secrets {
  
  include params
  
  $security_directory = $params::security_directory
  $internode_security = $params::internode_security
  
  group { "cassandra" :
    ensure => present,
  }
  
  user  { "cassandra" :
    ensure => present,
    require => Group["cassandra"]
  }  
  
  file { [ "${security_directory}", "${internode_security}" ] : 
    ensure => directory,
    group => "cassandra",
    owner => "cassandra",
    mode  => 0700,
    require => User["cassandra"]
  }

}
