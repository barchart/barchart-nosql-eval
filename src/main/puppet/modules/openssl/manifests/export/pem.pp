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
  $ensure=present
) {

  # Resource default for Exec
  Exec {
      path  => "${::path}",
  }
    
  case $ensure {
    present: {
      $pass_opt = $password ? {
        ''      => '',
        default => "-passout pass:${password}",
      }

      exec {"${name}":
        command => "openssl pkcs12 -in ${file_p12} -out ${name} -nodes ${pass_opt}",
        creates => "${name}",
      }
    }
    absent: {
      file {"${name}":
        ensure => absent,
      }
    }
  }
}
