
class helloworld {

    file { '/tmp/helloFromMaster':
            content => "Hello Puppet."
    }
        
}
