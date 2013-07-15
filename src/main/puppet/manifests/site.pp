#
# Cassandra cluster.
#

# Cluster name.
$cassandra_cluster_name = "Evaluator"

# Seed node list.
$cassandra_seeds = [
    "cassandra-01.eqx.barchart.com",
    "cassandra-01.us-east-1.aws.barchart.com",
    "cassandra-01.us-west-1.aws.barchart.com",
    "cassandra-02.eqx.barchart.com",
    "cassandra-02.us-east-1.aws.barchart.com",
    "cassandra-02.us-west-1.aws.barchart.com",
  ]

# Topology for properties snitch.
$cassandra_topology_properties = "
#
# Cassandra Node IP = Data Center : Rack
#
cassandra-01.eqx.barchart.com=eqx:az1
cassandra-02.eqx.barchart.com=eqx:az1
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
  include java00
  
}

# Operations center.
node /opsc.cassandra.aws.barchart.com/ inherits default {
  
}

# EQX cassandra nodes.
node /cassandra-.*.eqx.barchart.com/ inherits default {
  
  class { 'cassandra00' :
      max_heap_size => 2000m,
      heap_newsize  => 100m,
  }
  
}

# AWS cassandra nodes.
node /cassandra-.*.aws.barchart.com/ inherits default {

  class { 'cassandra00' :
      max_heap_size => 5000m,
      heap_newsize  => 300m,
  }
    
}
