#
#
#
class java00::install::ubuntu ($version) {

	package { "python-software-properties" : }
	 
	exec { "add-apt-repository-oracle":
	    command => "/usr/bin/add-apt-repository -y ppa:webupd8team/java",
	    notify => Exec["apt_update"]
	}
		 
	exec { "add-apt-repository-oracle":
	    command => "/usr/bin/add-apt-repository -y ppa:webupd8team/java",
	    notify => Exec["apt_update"]
	}
	 
	exec {
		"set-licence-selected":
			command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections';
		"set-licence-seen":
			command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections';
	}
	 
	package { 'oracle-java6-installer' :
	  ensure => "${version}",
	  require => [
	  	Exec['add-apt-repository-oracle'], 
	  	Exec['set-licence-selected'], 
	  	Exec['set-licence-seen'],
	  ],
	}

}
