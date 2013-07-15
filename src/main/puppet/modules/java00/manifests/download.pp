#
# http://ivan-site.com/2012/05/download-oracle-java-jre-jdk-using-a-script/
#
# http://projects.puppetlabs.com/projects/1/wiki/Download_File_Recipe_Patterns
#
define java00::download (
  
        $remote="",
        $local="",
        $timeout=300,
        $header = "Tester: tester",
        
    ) {                                                                                         

    # Resource default for Exec
    Exec {
        path  => "${::path}",
    }

    include packages    
    realize Package["wget"]     
          
    $options = "--no-cookies --no-check-certificate --header '${header}'"
      
    exec { $name:                                                                                                                     
        command => "wget ${options} -O ${name} ${remote}/${name}",                                                         
        cwd => $local,
        creates => "${local}/${name}",                                                              
        timeout => $timeout,
        require => Package["wget"],                                                                                         
    }
    
    file { "${local}/${name}":
      ensure => present,
      mode => 0755,
      backup => false,
      force => true,
      require => Exec[$name],                                                                                         
    }

}
