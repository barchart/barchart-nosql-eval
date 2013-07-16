
#include ntp

#include helloworld

include java_00

class { 'cassandra_00' :
  
    cluster_name  => 'evaluator',
      
    seeds         => [ 
      '127.0.0.1', 
    ],
    
    max_heap_size => 1500m,
    heap_newsize  => 100m,
    
}

#class { 'cassandra_00::opsc::master' :
#}

class { 'cassandra_00::opsc::agent' :
}

