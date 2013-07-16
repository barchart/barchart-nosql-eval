#
#
#
class cassandra_00::opsc::secrets {
  
  # Reuse puppet node security for the operations center.    
  
  $ssl_cafile   = "/var/lib/puppet/ssl/certs/ca.pem"
  $ssl_nodefile  = "/var/lib/puppet/ssl/certs/${fqdn}.pem"
  
  $ssl_certfile = "/var/lib/puppet/ssl/certs/web.pem"
  $ssl_keyfile  = "/var/lib/puppet/ssl/private_keys/${fqdn}.pem"

  # Agent keystore location and naming.

  $agent_lib = "/var/lib/opscenter-agent"
  $agent_ssl = "${agent_lib}/ssl"
  $agent_keystore = "${agent_ssl}/agentKeyStore"
  
  $keystore_ca   = "ca:${agent_keystore}"
  $keystore_key  = "agent_key:${agent_keystore}"
  $keystore_cert = "opscenter_cert:${agent_keystore}"
  
  $keystore_password = "opscenter"

  file { [ "${agent_lib}", "${agent_ssl}" ] : ensure => directory }

  # Make master cert based on puppet.
      
  file { "${ssl_certfile}" :
    require    => File[ "${agent_lib}", "${agent_ssl}" ],
    content => generate( "/bin/cat", "${ssl_cafile}", "${ssl_nodefile}" )
  }
    
  # Make agent keystore based on puppet.
  
  java_ks { "${keystore_ca}" :
    require    => File[ "${ssl_certfile}" ],
    ensure     => latest,
    certificate => "${ssl_cafile}",
    password    => "${keystore_password}",
  }
  
  java_ks { "${keystore_key}" :
    require    => Java_ks[ "${keystore_ca}" ],
    ensure     => latest,
    private_key => "${ssl_keyfile}",
    certificate => "${ssl_certfile}",
    password    => "${keystore_password}",
  }
  
  java_ks { "${keystore_cert}" :
    require    => Java_ks[ "${keystore_key}" ],
    ensure     => latest,
    certificate => "${ssl_certfile}",
    password    => "${keystore_password}",
  }
  
}
