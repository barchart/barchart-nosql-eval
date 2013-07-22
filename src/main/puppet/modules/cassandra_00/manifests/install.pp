#
#
#
class cassandra_00::install ()  {

    include params  

    if($params::include_repo) {
        class { 'repo':
            repo_name => $params::repo_name,
            baseurl   => $params::repo_baseurl,
            gpgkey    => $params::repo_gpgkey,
            repos     => $params::repo_repos,
            release   => $params::repo_release,
            pin       => $params::repo_pin,
            gpgcheck  => $params::repo_gpgcheck,
            enabled   => $params::repo_enabled,
        }
    }

    notify { "### package_name: ${params::package_name}": }
      
    package { $params::package_name :
      ensure => installed,
    }
        
}
