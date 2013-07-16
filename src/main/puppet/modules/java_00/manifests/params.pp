#
#
#
class java_00::params {

  # Install folder.
  $install = "/opt/oracle"  
  
  $java32 = "jdk-6u45-linux-i586.bin"
  $java64 = "jdk-6u45-linux-x64.bin"

  # Verify bitness.
  case $::architecture {
    'i386': {
      $java = "${java32}"
    }
    'amd64': {
      $java = "${java64}"
    }
    'x86_64': {
      $java = "${java64}"
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::architecture} based system.")
    }
  }

  notify {"JAVA $java":}

  case $::osfamily {
  
    'Debian': {
      $version  = '6u38-0~webupd8~0'
    }
    
    'RedHat': {
      $version  = 'XXX'
    }
    
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
    
  }
  
}
