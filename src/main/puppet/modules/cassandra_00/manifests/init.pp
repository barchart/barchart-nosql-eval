#
#
#
class cassandra_00 (

  $opscenter_host = $::cassandra_opscenter_host,

  $cluster_name = $::cassandra_cluster_name,
      
  $package_name = $::cassandra_package_name,
  $version = $::cassandra_version,
  
  $include_repo = $::cassandra_include_repo,
  $repo_name = $::cassandra_repo_name,
  $repo_baseurl = $::cassandra_repo_baseurl,
  $repo_gpgkey = $::cassandra_repo_gpgkey,
  $repo_repos = $::cassandra_repo_repos,
  $repo_release = $::cassandra_repo_release,
  $repo_pin = $::cassandra_repo_pin,
  $repo_gpgcheck = $::cassandra_repo_gpgcheck,
  $repo_enabled = $::cassandra_repo_enabled,
    
  $service_name = $::cassandra_service_name,
    
  $config_path = $::cassandra_config_path,

  $data_file_directory = $::cassandra_data_file_directory,
  $commit_log_directory = $::cassandra_commit_log_directory,
  $saved_caches_directory = $::cassandra_saved_caches_directory,
    
  $max_heap_size = $::cassandra_max_heap_size,
  $heap_newsize = $::cassandra_heap_newsize,
  $jmx_port = $::cassandra_jmx_port,
  $additional_jvm_opts = $::cassandra_additional_jvm_opts,
  
  $listen_address = $::cassandra_listen_address,
  $broadcast_address = $::cassandra_broadcast_address,
  $rpc_address = $::cassandra_rpc_address,
  $rpc_port = $::cassandra_rpc_port,
  $rpc_server_type = $::cassandra_rpc_server_type,
  $storage_port = $::cassandra_storage_port,
  $ssl_storage_port = $::cassandra_ssl_storage_port,
  
  $partitioner = $::cassandra_partitioner,
    
  $initial_token = $::cassandra_initial_token,
    
  $seeds = $::cassandra_node_list,
    
  $default_concurrent_reads = $::cassandra_default_concurrent_reads,
  $concurrent_reads = $::cassandra_concurrent_reads,
  $default_concurrent_writes = $::cassandra_default_concurrent_writes,
  $concurrent_writes = $::cassandra_concurrent_writes,
    
  $incremental_backups = $::cassandra_incremental_backups,
  $snapshot_before_compaction = $::cassandra_snapshot_before_compaction,
  $auto_snapshot = $::cassandra_auto_snapshot,
  
  $multithreaded_compaction = $::cassandra_multithreaded_compaction,
  $endpoint_snitch = $::cassandra_endpoint_snitch,
  $internode_compression = $::cassandra_internode_compression,
  $disk_failure_policy = $::cassandra_disk_failure_policy,
  
  $start_native_transport = $::cassandra_start_native_transport,
  $native_transport_port = $::cassandra_native_transport_port,
  $start_rpc = $::cassandra_start_rpc,
  
  $num_tokens = $::cassandra_num_tokens,
    
  $thread_stack_size = $::cassandra_thread_stack_size,
  
  $topology_properties = $::cassandra_topology_properties,
  
  $security_directory = $::cassandra_security_directory,

  $internode_encryption = $::cassandra_internode_encryption,
  
  $internode_security = $::cassandra_internode_security,
  
  $internode_keystore_location    = $::cassandra_internode_keystore_location,
  $internode_keystore_password    = $::cassandra_internode_keystore_password,
  $internode_truststore_location  = $::cassandra_internode_truststore_location,
  $internode_truststore_password  = $::cassandra_internode_truststore_password,
      
  ) {

    notify { "### ${seeds}" : }    

    include apply    

}
