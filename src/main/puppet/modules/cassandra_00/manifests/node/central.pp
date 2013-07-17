#
#
#
class cassandra_00::node::central {

  include params
  include secrets
  include cassandra_00::secrets

  # add node public keys to the trust store
  define key_add () {

    $puppet_signed = $cassandra_00::secrets::puppet_signed
    
    $truststore_location = $params::internode_truststore_location
    $truststore_password = $params::internode_truststore_password
          
    $truststore_entry = "${name}:${truststore_location}"
    $certificate_file = "${puppet_signed}/${name}.pem"
    
    java_ks { "${truststore_entry}" :
      trustcacerts => true,
      ensure     => latest,
      certificate => "${certificate_file}",
      password    => "${truststore_password}",
    }
    
  }

  key_add { $cassandra_node_list : }

}
