#
#
#
class cassandra_00::opsc::secrets {
  
  # Puppet resources.    
  $puppet_lib = "/var/lib/puppet"
  $puppet_ssl = "${puppet_lib}/ssl"
  $puppet_ca_file    = "${puppet_ssl}/certs/ca.pem"
  $puppet_cert_file  = "${puppet_ssl}/certs/${fqdn}.pem"
  $puppet_pkey_file  = "${puppet_ssl}/private_keys/${fqdn}.pem"
  
  # Master resources.
  $master_lib = "/var/lib/opscenter"
  $master_ssl = "${master_lib}/ssl"

  file { [ "${master_lib}", "${master_ssl}" ] : ensure => directory }
  
  $agent_file = "agentKeyStore"
    
  # Master [agents] section: ssl for stomp.
  $jks_keyfile = "${master_ssl}/${agent_file}"
  $p12_keyfile = "${master_ssl}/${agent_file}.p12"
  $pem_keyfile = "${master_ssl}/${agent_file}.pem"
  
  # Master [webserver] section: ssl for https.
  $ssl_keyfile  = "${master_ssl}/opscenter.key"
  $ssl_certfile = "${master_ssl}/opscenter.pem" 
  
  # Agent resources.
  $agent_lib = "/var/lib/opscenter-agent"
  $agent_ssl = "${agent_lib}/ssl"
  $agent_keyfile = "${agent_ssl}/${agent_file}"

  # Shared java key store.
  $keystore_ca  = "ca:${jks_keyfile}"
  $keystore_cert  = "cert:${jks_keyfile}"
  $keystore_entry  = "agent_key:${jks_keyfile}"
  $keystore_password = "opscenter"

  file { [ "${agent_lib}", "${agent_ssl}" ] : ensure => directory }

  # Load agent cert from master.
  file { "${agent_keyfile}" :
    require => File[ "${agent_ssl}" ],  
    source   => "puppet:///opscenter/ssl/${agent_file}",
  }  
      
}
