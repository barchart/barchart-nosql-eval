#
#
#
class cassandra_00::secrets {
  
  # Puppet resources.
      
  $puppet_lib = "/var/lib/puppet"
  $puppet_ssl = "${puppet_lib}/ssl"
  $puppet_signed = "${puppet_ssl}/ca/signed"
  $puppet_certs  = "${puppet_ssl}/certs"
  
  $puppet_ca_file    = "${puppet_certs}/ca.pem"
  $puppet_cert_file  = "${puppet_certs}/${fqdn}.pem"
  $puppet_pkey_file  = "${puppet_ssl}/private_keys/${fqdn}.pem"
  
}
