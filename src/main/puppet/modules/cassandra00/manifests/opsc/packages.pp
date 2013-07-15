#
#
#
class cassandra00::opsc::packages  (

  $opscenter = $params::opscenter
      
  ) {

    case $::osfamily {
        
        'Debian': {
          
          package { [ 'libssl0.9.8', 'opscenter' ] :
            ensure => installed,
          }
          
        }
        
        'RedHat': {
          
          package { [ 'opscenter' ] :
            ensure => installed,
          }
          
        }
        
        default: {
            fail("Unsupported osfamily: ${::osfamily}, operatingsystem: ${::operatingsystem}, module ${module_name}.")
        }
        
    }
      
}
