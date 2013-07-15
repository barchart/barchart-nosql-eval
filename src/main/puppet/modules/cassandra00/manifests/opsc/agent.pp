#
# http://www.datastax.com/docs/opscenter/agent/agent_manual#prerequisites
#
class cassandra00::opsc::agent (

  $opscenter_host = $params::opscenter_host
      
  ) {

    # Resource default for Exec
    Exec {
        path  => "${::path}",
    }
    
    include packages

    # Disable master service.    
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

    $agent_command = "${agent_install} ${agent_pack} ${opscenter_host}"
        
    $agent_store = "/var/lib/opscenter-agent"
    $agent_conf  = "${agent_store}/conf"
    $agent_address = "${agent_conf}/address.yaml"

    # Install agent.
    exec { "$agent_command" :
      cwd     => "/",
      creates => "$agent_address",
      require    => Service['opscenterd'],
    }

    # Enable agent service.
    service { 'opscenter-agent' :
        enable   => true,
        ensure  => running,
        require => Exec["$agent_command"],
    }
                
}
