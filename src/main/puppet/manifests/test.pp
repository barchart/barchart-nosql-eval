
#include ntp

#include helloworld

include java00

class { 'cassandra00' :
  
    cluster_name  => 'evaluator',
      
    seeds         => [ 
      '127.0.0.1', 
    ],
    
    max_heap_size => 1500m,
    heap_newsize  => 100m,
    
}

class { 'cassandra00::opsc::master' :
}
