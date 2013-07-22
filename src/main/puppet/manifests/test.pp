
#include ntp

#include helloworld

include java_00

$cassandra_node_list = [ 
#    "wks002.hsd1.il.comcast.net",
    "rasputin-02.servers.bcinc.internal",  
]

$cassandra_topology_properties = "
#
# Cassandra Node IP = Data Center : Rack
#
cassandra-01.eqx.barchart.com=eqx:az1
cassandra-02.eqx.barchart.com=eqx:az2
#
cassandra-01.us-east-1.aws.barchart.com=us-east-1:az1
cassandra-02.us-east-1.aws.barchart.com=us-east-1:az2
#
cassandra-01.us-west-1.aws.barchart.com=us-west-1:az1
cassandra-02.us-west-1.aws.barchart.com=us-west-1:az2
#
# default for unknown nodes
#
default=us-east-1:az1
"


  class { 'cassandra_00' :
    
      cluster_name  => 'evaluator',
        
      max_heap_size => 1500m,
      heap_newsize  => 100m,
      
  }
  class { 'cassandra_00::apply' : }

  class { 'cassandra_00::opsc::master' : }
  class { 'cassandra_00::node::central' : }

#  class { 'cassandra_00::opsc::agent' : }
#  class { 'cassandra_00::node::member' : }

