#
#
#
class cassandra_00::validate () {
  
    include params
    
    validate_bool($params::include_repo)
    validate_bool($params::start_rpc)
    validate_bool($params::start_native_transport)
    validate_bool($params::incremental_backups)
    validate_bool($params::snapshot_before_compaction)
    validate_bool($params::auto_snapshot)
    validate_bool($params::multithreaded_compaction)

    validate_absolute_path($params::data_file_directory)
    validate_absolute_path($params::commit_log_directory)
    validate_absolute_path($params::saved_caches_directory)

    validate_string($params::cluster_name)
    validate_string($params::partitioner)
    validate_string($params::initial_token)
    validate_string($params::endpoint_snitch)

    validate_re($params::rpc_server_type, '^(hsha|sync|async)$')
    validate_re($params::internode_compression, '^(all|dc|rack|none)$')
    validate_re($params::disk_failure_policy, '^(stop|best_effort|ignore)$')
    
    validate_array($params::additional_jvm_opts)
    validate_array($params::seeds)

    if(!is_integer($params::concurrent_reads)) {
        fail('concurrent_reads must be a number')
    }

    if(!is_integer($params::concurrent_writes)) {
        fail('concurrent_writes must be a number')
    }

    if(!is_integer($params::num_tokens)) {
        fail('num_tokens must be a number')
    }
            
    if(!is_integer($params::thread_stack_size)) {
        fail('thread_stack_size must be a number')
    }
                
    if(!is_integer($params::jmx_port)) {
        fail('jmx_port must be a port number between 1 and 65535')
    }

    if(!is_ip_address($params::listen_address)) {
        fail('listen_address must be an IP address')
    }

    if(!is_ip_address($params::rpc_address)) {
        fail('rpc_address must be an IP address')
    }

    if(!is_integer($params::rpc_port)) {
        fail('rpc_port must be a port number between 1 and 65535')
    }

    if(!is_integer($params::native_transport_port)) {
        fail('native_transport_port must be a port number between 1 and 65535')
    }

    if(!is_integer($params::storage_port)) {
        fail('storage_port must be a port number between 1 and 65535')
    }

    if(empty($params::seeds)) {
        fail('seeds must not be empty')
    }

    if(empty($params::data_file_directory)) {
        fail('data_file_directory must not be empty')
    }

    if(!empty($params::initial_token)) {
        fail("Starting with Cassandra 1.2 you shouldn't set an initial_token but set num_tokens accordingly.")
    }

}
