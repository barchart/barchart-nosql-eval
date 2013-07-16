#
#
#
class cassandra_00::opsc::secrets {
  
  # Reuse puppet node security for the operations center.    
  
  $ssl_cafile   = "/var/lib/puppet/ssl/certs/ca.pem"
  $ssl_certfile = "/var/lib/puppet/ssl/certs/${fqdn}.pem"
  $ssl_keyfile  = "/var/lib/puppet/ssl/private_keys/${fqdn}.pem"

  notify { "### ssl_cafile   : ${ssl_cafile}": }
  notify { "### ssl_certfile : ${ssl_certfile}": }
  notify { "### ssl_keyfile  : ${ssl_keyfile}" : }
  
  # Agent keystore location and naming.

  $agent_lib = "/var/lib/opscenter-agent"
  $agent_ssl = "${agent_lib}/ssl"
  $agent_keystore = "${agent_ssl}/agentKeyStore"
  
  $keystore_ca   = "ca:${agent_keystore}"
  $keystore_key  = "agent_key:${agent_keystore}"
  $keystore_cert = "opscenter_cert:${agent_keystore}"
  
  $keystore_password = "opscenter"

  file { [ "${agent_lib}", "${agent_ssl}" ] : ensure => directory }
  
  # Make agent keystore based on puppet.
  
  java_ks { "${keystore_ca}" :
    require    => File[ "${agent_lib}", "${agent_ssl}" ],
    ensure     => latest,
    certificate => "${ssl_cafile}",
    password    => "${keystore_password}",
  }
  
  java_ks { "${keystore_key}" :
    require    => "${keystore_ca}",
    ensure     => latest,
    private_key => "${ssl_keyfile}",
    certificate => "${ssl_certfile}",
    password    => "${keystore_password}",
  }
  
  java_ks { "${keystore_cert}" :
    require    => "${keystore_key}",
    ensure     => latest,
    certificate => "${ssl_certfile}",
    password    => "${keystore_password}",
  }
  
}
