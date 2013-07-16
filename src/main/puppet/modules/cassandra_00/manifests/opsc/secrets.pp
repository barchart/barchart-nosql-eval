#
#
#
class cassandra_00::opsc::secrets {
  
  # Reuse puppet node security for the operations center.    
  
  $ssl_keyfile  = "/var/lib/puppet/ssl/private_keys/${fqdn}.pem"
  $ssl_certfile = "/var/lib/puppet/ssl/certs/${fqdn}.pem"

  notify { "### ssl_certfile : ${ssl_certfile}": }
  notify { "### ssl_keyfile : ${ssl_keyfile}" : }
  
  # Agent keystore location and naming.
  
  $agent_keystore =  "/var/lib/opscenter-agent/ssl/agentKeyStore"
  $keystore_agent_key =            "agent_key:${agent_keystore}"
  $keystore_opscenter_cert =  "opscenter_cert:${agent_keystore}"
  $opscenter_password = "opscenter"

  # Make agent keystore based on puppet.
  
  java_ks { "${keystore_agent_key}" :
    ensure     => present,
    private_key => "${ssl_keyfile}",
    certificate => "${ssl_certfile}",
    password    => "${opscenter_password}",
  }
  
  java_ks { "${keystore_opscenter_cert}" :
    ensure     => present,
    certificate => "${ssl_certfile}",
    password    => "${opscenter_password}",
  }
  
}
