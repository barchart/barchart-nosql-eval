
#include ntp

#include helloworld

include java_00

$cassandra_node_list = [ 
  "wks002.hsd1.il.comcast.net", 
]

class { 'cassandra_00' :
  
    cluster_name  => 'evaluator',
      
    max_heap_size => 1500m,
    heap_newsize  => 100m,
    
}

#  class { 'cassandra_00::opsc::master' : }
#  class { 'cassandra_00::node::central' : }

  class { 'cassandra_00::opsc::agent' : }
  class { 'cassandra_00::node::member' : }

