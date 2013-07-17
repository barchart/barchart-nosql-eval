#
#
#
class cassandra_00::node::member {

  include params
  include secrets
  include cassandra_00::secrets

  $keystore_location = $params::internode_keystore_location
  $keystore_password = $params::internode_keystore_password
  
  $puppet_cert_file = $cassandra_00::secrets::puppet_cert_file
  $puppet_pkey_file = $cassandra_00::secrets::puppet_pkey_file
  
  $keystore_entry = "${fqdn}:${keystore_location}" 
  
  # private node key store
  java_ks { "${keystore_entry}" :
    trustcacerts => true,
    ensure     => latest,
    certificate => "${puppet_cert_file}",
    private_key => "${puppet_pkey_file}",
    password    => "${keystore_password}",
  }
  
}
