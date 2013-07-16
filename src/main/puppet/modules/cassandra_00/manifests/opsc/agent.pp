#
# http://www.datastax.com/docs/opscenter/agent/agent_manual#prerequisites
#
class cassandra_00::opsc::agent (

  ) {

    include packages
    include secrets
    include params

    $opscenter_host = $params::opscenter_host

    $agent_keyfile = $secrets::agent_keyfile
        
    #
    
    # Resource default for Exec
    Exec {
        path  => "${::path}",
    }
        
    # Agent uses master for package delivery.
    service { 'opscenterd' :
        enable     => false,
        ensure     => stopped,
        require    => Package['opscenter'],
    }
    
    $master_shared = "/usr/share/opscenter"
    $agent_shared  = "${master_shared}/agent"
    
    $agent_install = "${agent_shared}/bin/install_agent.sh"
    $agent_pack_deb ="${agent_shared}/opscenter-agent.deb"
    $agent_pack_rpm ="${agent_shared}/opscenter-agent.rpm"
    
    $agent_pack = $::osfamily ? {
          'Debian' => "$agent_pack_deb",
          'RedHat' => "$agent_pack_rpm",
          default  => undef,
    }

    # Installer invocation.
    $java_home_sh = "/etc/profile.d/java-home.sh"
    $agent_command = "${java_home_sh} ; ${agent_install} ${agent_pack} ${opscenter_host}"
        
    $agent_lib = "/var/lib/opscenter-agent"
    $agent_conf  = "${agent_lib}/conf"
    $agent_address = "${agent_conf}/address.yaml"

    # Invoke agent install.
    exec { "${agent_command}" :
      cwd     => "/",
      creates => "${agent_address}",
      require    => Service['opscenterd'],
    }

    $agent_etc = "/etc/opscenter-agent"
    $agent_env_sh = "${agent_etc}/opscenter-agent-env.sh"
    
    file { "${agent_etc}" :
        ensure  => directory,
    }
    
    # Provide agent environment.
    file { "${agent_env_sh}":
        content  => template("${module_name}/opscenter-agent-env.sh.erb"),
    }
    
    # Agent network configuration.
    $agent_rpc_interface         = $params::listen_address
    $agent_rpc_broadcast_address = $params::broadcast_address
    $local_interface             = $params::broadcast_address
    $stomp_interface             = $params::opscenter_host
    #
    file { "${agent_address}" :
      content  => template("${module_name}/opscenter-agent-address.yaml.erb"),
    }
    
    # Enable agent service.
    service { 'opscenter-agent' :
        enable   => true,
        ensure  => running,
        require => Exec[ "${agent_command}" ], 
        subscribe => [
          File[ "${agent_env_sh}", "${java_home_sh}" ],
          File[ "${agent_address}", "${agent_keyfile}" ],
        ]
    }
    
}
