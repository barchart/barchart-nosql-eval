#
#
#
class cassandra_00::config () {

  include params
  include install
  
  $cassandraGroup = 'cassandra'
  $cassandraAgent = 'cassandra'
  
  $opscenterGroup = 'opscenter-admin'
  $opscenterAgent = 'opscenter-agent'

  group { $cassandraGroup :
    ensure  => present,
  }
  
  group { $opscenterGroup :
    ensure  => present,
  }

  user  { $cassandraAgent :
    gid => $cassandraGroup,
    ensure  => present,
    require => Group[$cassandra],
  }

  user  { $opscenterAgent :
    gid => $opscenterGroup,
    groups => [$cassandra, $opscenterGroup], 
    ensure  => present,
    require => Group[ $cassandra, $opscenterGroup ],
  }

  File {
    owner   => $cassandra,
    group   => $cassandra,
    mode    => '0770',
  }

  file { [
    $params::var_lib_directory,
    $params::data_file_directory,
    $params::commit_log_directory,
    $params::saved_caches_directory,
    $params::security_directory, 
    $params::internode_security, 
    ] :
    ensure  => directory,
    require => User[$cassandra],
  }
  
  file { "${params::config_path}/cassandra-env.sh":
      ensure  => file,
      content => template("${module_name}/cassandra-env.sh.erb"),
  }

  file { "${params::config_path}/cassandra.yaml":
      ensure  => file,
      content => template("${module_name}/cassandra.yaml.erb"),
  }
  
  # PropertiesSnitch
  file { "${params::config_path}/cassandra-topology.properties" :
      content => $params::topology_properties,
  }    

  # TODO parameterize
  file { "/etc/dse/dse-env.sh":
      ensure  => file,
      content => template("${module_name}/dse-env.sh.erb"),
  }
  
}
