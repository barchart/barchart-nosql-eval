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
define openssl::export::pem(
  $file_p12,
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

      $security = "-passin pass:${password} -passout pass:${password}"
      
      exec {"${name}" :
        subscribe => $eventer, 
        refreshonly => true,
        command => "openssl pkcs12 -in ${file_p12} -out ${name} ${security}",
      }
    }

    absent: {
      file {"${name}":
        ensure => absent,
      }
    }
  }
}
