#
# http://www.datastax.com/docs/opscenter/agent/agent_manual#prerequisites
#
class cassandra_00::opsc::agent (

  ) {

    include packages
    include secrets
    include params

    $opscenter_host = $params::opscenter_host
    
    $keystore_agent_key      = $secrets::keystore_agent_key
    $keystore_opscenter_cert = $secrets::keystore_opscenter_cert

    #
    
    # Resource default for Exec
    Exec {
        path  => "${::path}",
    }
        
    # Disable master service.    
    service { 'opscenterd' :
        enable     => false,
        ensure     => stopped,
        require    => Package['opscenter'],
    }
    
    $java_home_sh = "/etc/profile.d/java-home.sh"

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

    $agent_command = "${java_home_sh} ; ${agent_install} ${agent_pack} ${opscenter_host}"
        
    $agent_lib = "/var/lib/opscenter-agent"
    $agent_conf  = "${agent_lib}/conf"
    $agent_address = "${agent_conf}/address.yaml"

    # Install agent.
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
    
    file { "${agent_env_sh}":
        ensure  => file,
        content  => template("${module_name}/opscenter-agent-env.sh.erb"),
    }
    
    # Enable agent service.
    service { 'opscenter-agent' :
        enable   => true,
        ensure  => running,
        require => Exec[ "${agent_command}" ], 
        subscribe => [
          File[ "${agent_etc}", "${agent_env_sh}", "${java_home_sh}" ],
          Java_ks[ "${keystore_agent_key}", "${keystore_opscenter_cert}" ],
        ],
    }
    
}
