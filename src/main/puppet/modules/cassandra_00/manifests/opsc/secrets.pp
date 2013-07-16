#
#
#
class cassandra_00::opsc::secrets {
  
  # Reuse puppet node security for the operations center.    
  $puppet_lib = "/var/lib/puppet"
  $puppet_ssl = "${puppet_lib}/ssl"
  $puppet_ca_file    = "${puppet_ssl}/certs/ca.pem"
  $puppet_cert_file  = "${puppet_ssl}/certs/${fqdn}.pem"
  $puppet_pkey_file  = "${puppet_ssl}/private_keys/${fqdn}.pem"
  
  # master
  $master_lib = "/var/lib/opscenter"
  $master_ssl = "${master_lib}/ssl"

  file { [ "${master_lib}", "${master_ssl}" ] : ensure => directory }
    
  # master [agents]: ssl for stomp
  $jks_keyfile = "${master_ssl}/agentKeyStore"
  $p12_keyfile = "${master_ssl}/agentKeyStore.p12"
  $pem_keyfile = "${master_ssl}/agentKeyStore.pem"
  
  # master [webserver]: ssl for https
  $ssl_keyfile  = "${master_ssl}/opscenter.key"
  $ssl_certfile = "${master_ssl}/opscenter.pem" 
  
  # agent: ssl for both stomp and https
  $agent_lib = "/var/lib/opscenter-agent"
  $agent_ssl = "${agent_lib}/ssl"
  $agent_keyfile = "${agent_ssl}/agentKeyStore"

  file { [ "${agent_lib}", "${agent_ssl}" ] : ensure => directory }
    
  # shared java store
  $keystore_entry  = "agent_key:${jks_keyfile}"
  $keystore_password = "opscenter"

  # master / jks
  java_ks { "${keystore_entry}" :
    ensure     => latest,
    certificate => "${puppet_cert_file}",
    private_key => "${puppet_pkey_file}",
    password    => "${keystore_password}",
  }

  # master / p12
  openssl::export::p12 { "${p12_keyfile}" :
    ensure     => present,
    entry_name  => "agent_key", 
    certificate => "${puppet_cert_file}",
    private_key => "${puppet_pkey_file}",
    password    => "${keystore_password}",
    eventer => Java_ks[ "${keystore_entry}" ],
  }
  
  # master / pem
  openssl::export::pem { "${pem_keyfile}" :
    ensure   => present,
    require  => Openssl::Export::P12[ "${p12_keyfile}" ],  
    file_p12  => "${p12_keyfile}",
    password  => "${keystore_password}",
    eventer => Java_ks[ "${keystore_entry}" ],
  }

  # master cert
  file { "${ssl_certfile}" :
     ensure  => link,
     target   => "${puppet_cert_file}",
  }  
      
  # master key
  file { "${ssl_keyfile}" :
     ensure  => link,
     target   => "${puppet_pkey_file}",
  }  

  # agent jks
  file { "${agent_keyfile}" :
   require => Java_ks[ "${keystore_entry}" ], 
   ensure  => link,
   target   => "${jks_keyfile}",
  }  

}
