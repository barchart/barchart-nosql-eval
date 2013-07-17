#
#
#
class cassandra_00::node::secrets {
  
  include params
  
  $security_directory = $params::security_directory
  $internode_security = $params::internode_security
  
  file { [ "${security_directory}", "${internode_security}" ] : 
    ensure => directory,
    group => "cassandra",
    owner => "cassandra",
    mode  => 0700,
  }

}
