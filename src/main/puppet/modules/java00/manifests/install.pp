#
#
#
class java00::install {

  include params
  
  $install = $params::install
  $java = $params::java
  $java32 = $params::java32
  $java64 = $params::java64
  
  file { "${install}" :
      ensure => "directory",
  }
  
  download { "${java32}" :
    remote => "http://download.oracle.com/otn-pub/java/jdk/6u45-b06/" ,
    local  => "${install}",
    header => "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F",
  }
  
  download { "${java64}" :
    remote => "http://download.oracle.com/otn-pub/java/jdk/6u45-b06/" ,
    local  => "${install}",
    header => "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F",
  }
  
  # Resource default for Exec
  Exec {
      path  => "${::path}",
  }

  # Downlaod result
  $java_base = "${install}/${java}"
  
  # Extract download.    
  $java_temp = "${$install}/${java}-temp"
  exec { "temp-${java}":
    cwd     => $install,
    command => "mkdir ${java_temp} ; cd ${java_temp} ; ../${java} ",
    creates => "${java_temp}",
    require => File["${java_base}"],
  }

  # Relocate extract.    
  $java_root = "${$install}/${java}-root"
  exec { "move-${java}":
    cwd     => $install,
    command => "mv ${java_temp}/* ${java_root}",
    creates => "${java_root}",
    require => Exec["temp-${java}"],
  }

  # Provide JAVA_HOME
  file { "/etc/profile.d/java-home.sh":
    backup => false, 
    mode   => 0755,
    content => "export JAVA_HOME=${java_root}",
    ensure => file, 
    require => Exec["move-${java}"],
  }

}
