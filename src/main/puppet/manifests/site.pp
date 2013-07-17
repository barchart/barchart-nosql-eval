#
# Cassandra cluster.
#

# Cluster name.
$cassandra_cluster_name = "Evaluator"

# Operations center.
$cassandra_opscenter_host = "opsc.cassandra.aws.barchart.com"

# Complete node list.
$cassandra_node_list = [
    "cassandra-01.eqx.barchart.com",
    "cassandra-01.us-east-1.aws.barchart.com",
    "cassandra-01.us-west-1.aws.barchart.com",
    "cassandra-02.eqx.barchart.com",
    "cassandra-02.us-east-1.aws.barchart.com",
    "cassandra-02.us-west-1.aws.barchart.com",
  ]

# Topology for PropertyFileSnitch.
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
  
# Default setup.
node default {

  # Require time sync.
  include ntp
  
  # Require common java.
  include java_00
  
}

# Operations center.
node "opsc.cassandra.aws.barchart.com" inherits default {

  class { "cassandra_00::opsc::master" :  }
  class { "cassandra_00::node::central" : }
      
}

# EQX cassandra nodes.
node /cassandra-.*.eqx.barchart.com/ inherits default {
  
  class { 'cassandra_00' :
      max_heap_size => 2000m,
      heap_newsize  => 100m,
  }

  class { "cassandra_00::opsc::agent" : }
  class { "cassandra_00::node::member" : }
    
}

# AWS cassandra nodes.
node /cassandra-.*.aws.barchart.com/ inherits default {

  
  class { "cassandra_00" :
      max_heap_size => 6000m,
      heap_newsize  => 300m,
  }

  class { "cassandra_00::opsc::agent" : }
  class { "cassandra_00::node::member" : }
      
}
