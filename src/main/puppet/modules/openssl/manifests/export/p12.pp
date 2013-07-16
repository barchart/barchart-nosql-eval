# == Definition: openssl::export::pkcs12
#
# Export a key pair to PKCS12 format
#
# == Parameters
#   [*basedir*]   - directory where you want the export to be done. Must exists
#   [*pkey*]      - private key
#   [*cert*]      - certificate
#   [*pkey_pass*] - private key password
#
define openssl::export::p12(
  $entry_name,
  $private_key,
  $certificate,
  $password,
  $ensure,
  $eventer, 
) {

  # Resource default for Exec
  Exec {
      path  => "${::path}",
  }

  case $ensure {
    
    present: {

      $security = "-passout pass:${password}"

      exec {"${name}":
        subscribe => $eventer, 
        refreshonly => true,
        command => "openssl pkcs12 -export -in ${certificate} -inkey ${private_key} -out ${name} -name ${entry_name} ${security}",
      }
    }
    
    absent: {
      file {"${name}":
        ensure => absent,
      }
    }
    
  }
  
}
