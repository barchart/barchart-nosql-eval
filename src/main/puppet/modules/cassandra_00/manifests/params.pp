#
#
#
class cassandra_00::params {

    $opscenter_host = $cassandra_00::opscenter_host ? {
        undef   => "opsc",
        default => $cassandra_00::opscenter_host,
    }
      
    $include_repo = $cassandra_00::include_repo ? {
        undef   => true,
        default => $cassandra_00::include_repo
    }

    $repo_name = $cassandra_00::repo_name ? {
        undef   => 'datastax-enterprise',
        default => $cassandra_00::repo_name
    }

    $repo_baseurl = $cassandra_00::repo_baseurl ? {
        undef   => $::osfamily ? {
            'Debian' => 'http://Andrei.Pozolotin_barchart.com:m14IP0aKyx4SVn1@debian.datastax.com/enterprise',
            'RedHat' => 'http://Andrei.Pozolotin_barchart.com:m14IP0aKyx4SVn1@rpm.datastax.com/enterprise',
            default  => undef,
        },
        default => $cassandra_00::repo_baseurl
    }

    $repo_gpgkey = $cassandra_00::repo_gpgkey ? {
        undef   => $::osfamily ? {
            'Debian' => 'http://debian.datastax.com/debian/repo_key',
            'RedHat' => 'http://rpm.datastax.com/rpm/repo_key',
            default  => undef,
        },
        default => $cassandra_00::repo_gpgkey
    }

    $repo_repos = $cassandra_00::repo_repos ? {
        undef   => 'main',
        default => $cassandra_00::repo_release
    }

    $repo_release = $cassandra_00::repo_release ? {
        undef   => 'stable',
        default => $cassandra_00::repo_release
    }

    $repo_pin = $cassandra_00::repo_pin ? {
        undef   => 200,
        default => $cassandra_00::repo_release
    }

    $repo_gpgcheck = $cassandra_00::repo_gpgcheck ? {
        undef   => 0,
        default => $cassandra_00::repo_gpgcheck
    }

    $repo_enabled = $cassandra_00::repo_enabled ? {
        undef   => 1,
        default => $cassandra_00::repo_enabled
    }

    case $::osfamily {
        
        'Debian': {
            $package_name = $cassandra_00::package_name ? {
                undef   => 'dse-full',
                default => $cassandra_00::package_name,
            }

            $service_name = $cassandra_00::service_name ? {
                undef   => 'dse',
                default => $cassandra_00::service_name,
            }

            $config_path = $cassandra_00::config_path ? {
                undef   => '/etc/dse/cassandra',
                default => $cassandra_00::config_path,
            }
        }
        
        'RedHat': {
            $package_name = $cassandra_00::package_name ? {
                undef   => 'dse-full',
                default => $cassandra_00::package_name,
            }

            $service_name = $cassandra_00::service_name ? {
                undef   => 'dse',
                default => $cassandra_00::service_name,
            }

            $config_path = $cassandra_00::config_path ? {
                undef   => '/etc/dse/cassandra',
                default => $cassandra_00::config_path,
            }
        }
        
        default: {
            fail("Unsupported osfamily: ${::osfamily}, in module ${module_name}.")
        }
        
    }

    $version = $cassandra_00::version ? {
        undef   => 'installed',
        default => $cassandra_00::version,
    }

    $max_heap_size = $cassandra_00::max_heap_size ? {
        undef   => '',
        default => $cassandra_00::max_heap_size,
    }

    $heap_newsize = $cassandra_00::heap_newsize ? {
        undef   => '',
        default => $cassandra_00::heap_newsize,
    }

    $jmx_port = $cassandra_00::jmx_port ? {
        undef   => 7199,
        default => $cassandra_00::jmx_port,
    }

    $additional_jvm_opts = $cassandra_00::additional_jvm_opts ? {
        undef   => [],
        default => $cassandra_00::additional_jvm_opts,
    }

    $cluster_name = $cassandra_00::cluster_name ? {
        undef   => 'Cassandra',
        default => $cassandra_00::cluster_name,
    }

    # 
    $listen_address = $cassandra_00::listen_address ? {
        undef   => $ipaddress, # from facter
        default => $cassandra_00::listen_address,
    }

    $broadcast_address = $cassandra_00::broadcast_address ? {
        undef   => $fqdn, # from facter
        default => $cassandra_00::broadcast_address,
    }
    
    $rpc_address = $cassandra_00::rpc_address ? {
        undef   => $ipaddress, # from facter
        default => $cassandra_00::rpc_address,
    }

    $rpc_port = $cassandra_00::rpc_port ? {
        undef   => 9160,
        default => $cassandra_00::rpc_port,
    }

    $rpc_server_type = $cassandra_00::rpc_server_type ? {
        undef   => 'hsha',
        default => $cassandra_00::rpc_server_type,
    }

    $storage_port = $cassandra_00::storage_port ? {
        undef   => 7000,
        default => $cassandra_00::storage_port,
    }

    $ssl_storage_port = $cassandra_00::ssl_storage_port ? {
        undef   => 7001,
        default => $cassandra_00::ssl_storage_port,
    }
    
    $partitioner = $cassandra_00::partitioner ? {
        undef   => 'org.apache.cassandra.dht.Murmur3Partitioner',
        default => $cassandra_00::partitioner,
    }
    
    $var_lib_directory = "/var/lib/cassandra"

    $data_file_directory = $cassandra_00::data_file_directory ? {
        undef   => "${var_lib_directory}/data_file",
        default => $cassandra_00::data_file_directory,
    }

    $commit_log_directory = $cassandra_00::commit_log_directory ? {
        undef   => "${var_lib_directory}/commit_log",
        default => $cassandra_00::commit_log_directory,
    }

    $saved_caches_directory = $cassandra_00::saved_caches_directory ? {
        undef   => "${var_lib_directory}/saved_caches",
        default => $cassandra_00::saved_caches_directory,
    }

    $initial_token = $cassandra_00::initial_token ? {
        undef   => '',
        default => $cassandra_00::initial_token,
    }

    $seeds = $cassandra_00::node_list ? {
        undef   => [],
        default => $cassandra_00::node_list,
    }

    $default_concurrent_reads = $::processorcount * 8
    $concurrent_reads = $cassandra_00::concurrent_reads ? {
        undef   => $default_concurrent_reads,
        default => $cassandra_00::concurrent_reads,
    }

    $default_concurrent_writes = $::processorcount * 8
    $concurrent_writes = $cassandra_00::concurrent_writes ? {
        undef   => $default_concurrent_writes,
        default => $cassandra_00::concurrent_writes,
    }

    $incremental_backups = $cassandra_00::incremental_backups ? {
        undef   => false,
        default => $cassandra_00::incremental_backups,
    }

    $snapshot_before_compaction = $cassandra_00::snapshot_before_compaction ? {
        undef   => false,
        default => $cassandra_00::snapshot_before_compaction,
    }

    $auto_snapshot = $cassandra_00::auto_snapshot ? {
        undef   => true,
        default => $cassandra_00::auto_snapshot,
    }

    $multithreaded_compaction = $cassandra_00::multithreaded_compaction ? {
        undef   => false,
        default => $cassandra_00::multithreaded_compaction,
    }

    $endpoint_snitch = $cassandra_00::endpoint_snitch ? {
        undef   => 'PropertyFileSnitch',
        default => $cassandra_00::endpoint_snitch,
    }

    $internode_compression = $cassandra_00::internode_compression ? {
        undef   => 'all',
        default => $cassandra_00::internode_compression,
    }

    $disk_failure_policy = $cassandra_00::disk_failure_policy ? {
        undef   => 'stop',
        default => $cassandra_00::disk_failure_policy,
    }

    $start_native_transport = $cassandra_00::start_native_transport ? {
        undef   => false,
        default => $cassandra_00::start_native_transport,
    }

    $native_transport_port = $cassandra_00::native_transport_port ? {
        undef   => 9042,
        default => $cassandra_00::native_transport_port,
    }

    $start_rpc = $cassandra_00::start_rpc ? {
        undef   => true,
        default => $cassandra_00::start_rpc,
    }

    $num_tokens = $cassandra_00::num_tokens ? {
        undef   => 256,
        default => $cassandra_00::num_tokens,
    }

    $thread_stack_size = $cassandra_00::thread_stack_size ? {
        undef   => 180,
        default => $cassandra_00::thread_stack_size,
    }
    
    $topology_properties = $cassandra_00::topology_properties ? {
      undef   => "",
      default => $cassandra_00::topology_properties,
    }

    $security_directory = $cassandra_00::security_directory ? {
        undef   => "/var/lib/cassandra/security",
        default => $cassandra_00::security_directory,
    }
        
    # all/none/dc/rack
    $internode_encryption = $cassandra_00::internode_encryption ? {
        undef   => "none",
        default => $cassandra_00::internode_encryption,
    }

    $internode_security = "${security_directory}/internode"

    # contains the private and public key for the current node
    $internode_keystore_location    = "${internode_security}/keystore.jks"
    
    # 
    $internode_keystore_password    = 'cassandra'
  
    # contains all the public keys for all the other nodes in the cluster
    $internode_truststore_location  = "${internode_security}/truststore.jks"

    # 
    $internode_truststore_password  = 'cassandra'

}
