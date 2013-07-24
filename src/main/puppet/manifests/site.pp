#
# Cassandra cluster.
#

# Cluster name.
$cassandra_cluster_name = "Evaluator"

# Cluster node-to-node security.
$cassandra_internode_encryption = "none"

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

  limits::fragment {
    "*/soft/nofile":
      value => "1024";
    "*/hard/nofile":
      value => "8192";
  }
    
  # Require time sync.
  include ntp
  
  # Require common java.
  include java_00

  # Disable java heap swap.  
  sysctl { 'vm.swappiness':
    ensure    => 'present',
    permanent => 'yes',
    value     => '0',
  }
  
  # Increase r/w socket buffer.
  sysctl { 'net.core.rmem_max':
    ensure    => 'present',
    permanent => 'yes',
    value     => '16777216',
  }
  sysctl { 'net.core.wmem_max':
    ensure    => 'present',
    permanent => 'yes',
    value     => '16777216',
  }
  
}

# Operations center.
node "opsc.cassandra.aws.barchart.com" inherits default {

  class { 'cassandra_00' :
  }
  class { "cassandra_00::opsc::master" :  }
  class { "cassandra_00::node::central" : }
      
}

# EQX cassandra nodes.
node /cassandra-.*.eqx.barchart.com/ inherits default {
  
  class { "cassandra_00" :
      max_heap_size => 2000m,
      heap_newsize  => 100m,
  }
  class { "cassandra_00::apply" : }
  class { "cassandra_00::opsc::agent" : }
  class { "cassandra_00::node::member" : }
    
}

# AWS cassandra nodes.
node /cassandra-.*.aws.barchart.com/ inherits default {
  
  class { "cassandra_00" :
      max_heap_size => 6000m,
      heap_newsize  => 300m,
      var_lib_directory => "/mnt/cassandra", 
  }
  class { "cassandra_00::apply" : }
  class { "cassandra_00::opsc::agent" : }
  class { "cassandra_00::node::member" : }
      
}
