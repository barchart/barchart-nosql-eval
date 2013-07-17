#
#
#
class cassandra_00 (
  
    $package_name               = $params::package_name,
    $version                    = $params::version,
    $service_name               = $params::service_name,
    $config_path                = $params::config_path,
    $include_repo               = $params::include_repo,
    $repo_name                  = $params::repo_name,
    $repo_baseurl               = $params::repo_baseurl,
    $repo_gpgkey                = $params::repo_gpgkey,
    $repo_repos                 = $params::repo_repos,
    $repo_release               = $params::repo_release,
    $repo_pin                   = $params::repo_pin,
    $repo_gpgcheck              = $params::repo_gpgcheck,
    $repo_enabled               = $params::repo_enabled,
    $max_heap_size              = $params::max_heap_size,
    $heap_newsize               = $params::heap_newsize,
    $jmx_port                   = $params::jmx_port,
    $additional_jvm_opts        = $params::additional_jvm_opts,
    $cluster_name               = $params::cluster_name,
    $listen_address             = $params::listen_address,
    $start_native_transport     = $params::start_native_transport,
    $start_rpc                  = $params::start_rpc,
    $rpc_address                = $params::rpc_address,
    $rpc_port                   = $params::rpc_port,
    $rpc_server_type            = $params::rpc_server_type,
    $native_transport_port      = $params::native_transport_port,
    $storage_port               = $params::storage_port,
    $ssl_storage_port           = $params::ssl_storage_port,
    $partitioner                = $params::partitioner,
    $data_file_directories      = $params::data_file_directories,
    $commitlog_directory        = $params::commitlog_directory,
    $saved_caches_directory     = $params::saved_caches_directory,
    $initial_token              = $params::initial_token,
    $num_tokens                 = $params::num_tokens,
    $seeds                      = $params::seeds,
    $concurrent_reads           = $params::concurrent_reads,
    $concurrent_writes          = $params::concurrent_writes,
    $incremental_backups        = $params::incremental_backups,
    $snapshot_before_compaction = $params::snapshot_before_compaction,
    $auto_snapshot              = $params::auto_snapshot,
    $multithreaded_compaction   = $params::multithreaded_compaction,
    $endpoint_snitch            = $params::endpoint_snitch,
    $internode_compression      = $params::internode_compression,
    $disk_failure_policy        = $params::disk_failure_policy,
    $thread_stack_size          = $params::thread_stack_size,

    $internode_encryption          = $params::internode_encryption,
    $internode_keystore_location   = $params::internode_keystore_location,
    $internode_keystore_password   = $params::internode_keystore_password,
    $internode_truststore_location = $params::internode_truststore_location,
    $internode_truststore_password = $params::internode_truststore_password,
        
    ) inherits params {
  

    # Validate input parameters
  
    validate_bool($include_repo)

    validate_absolute_path($commitlog_directory)
    validate_absolute_path($saved_caches_directory)

    validate_string($cluster_name)
    validate_string($partitioner)
    validate_string($initial_token)
    validate_string($endpoint_snitch)

    validate_re($start_rpc, '^(true|false)$')
    validate_re($start_native_transport, '^(true|false)$')
    validate_re($rpc_server_type, '^(hsha|sync|async)$')
    validate_re($incremental_backups, '^(true|false)$')
    validate_re($snapshot_before_compaction, '^(true|false)$')
    validate_re($auto_snapshot, '^(true|false)$')
    validate_re($multithreaded_compaction, '^(true|false)$')
    validate_re("${concurrent_reads}", '^[0-9]+$')
    validate_re("${concurrent_writes}", '^[0-9]+$')
    validate_re("${num_tokens}", '^[0-9]+$')
    validate_re($internode_compression, '^(all|dc|none)$')
    validate_re($disk_failure_policy, '^(stop|best_effort|ignore)$')
    validate_re("${thread_stack_size}", '^[0-9]+$')

    validate_array($additional_jvm_opts)
    validate_array($seeds)
    validate_array($data_file_directories)

    if(!is_integer($jmx_port)) {
        fail('jmx_port must be a port number between 1 and 65535')
    }

    if(!is_ip_address($listen_address)) {
        fail('listen_address must be an IP address')
    }

    if(!is_ip_address($rpc_address)) {
        fail('rpc_address must be an IP address')
    }

    if(!is_integer($rpc_port)) {
        fail('rpc_port must be a port number between 1 and 65535')
    }

    if(!is_integer($native_transport_port)) {
        fail('native_transport_port must be a port number between 1 and 65535')
    }

    if(!is_integer($storage_port)) {
        fail('storage_port must be a port number between 1 and 65535')
    }

    if(empty($seeds)) {
        fail('seeds must not be empty')
    }

    if(empty($data_file_directories)) {
        fail('data_file_directories must not be empty')
    }

    if(!empty($initial_token)) {
        fail("Starting with Cassandra 1.2 you shouldn't set an initial_token but set num_tokens accordingly.")
    }

    # Anchors for containing the implementation class
    
    anchor { 'begin': }

    include install

    class { 'config':
        config_path                => $config_path,
        max_heap_size              => $max_heap_size,
        heap_newsize               => $heap_newsize,
        jmx_port                   => $jmx_port,
        additional_jvm_opts        => $additional_jvm_opts,
        cluster_name               => $cluster_name,
        start_native_transport     => $start_native_transport,
        start_rpc                  => $start_rpc,
        listen_address             => $listen_address,
        broadcast_address          => $broadcast_address,
        rpc_address                => $rpc_address,
        rpc_port                   => $rpc_port,
        rpc_server_type            => $rpc_server_type,
        native_transport_port      => $native_transport_port,
        storage_port               => $storage_port,
        ssl_storage_port           => $ssl_storage_port,
        partitioner                => $partitioner,
        data_file_directories      => $data_file_directories,
        commitlog_directory        => $commitlog_directory,
        saved_caches_directory     => $saved_caches_directory,
        initial_token              => $initial_token,
        num_tokens                 => $num_tokens,
        seeds                      => $seeds,
        concurrent_reads           => $concurrent_reads,
        concurrent_writes          => $concurrent_writes,
        incremental_backups        => $incremental_backups,
        snapshot_before_compaction => $snapshot_before_compaction,
        auto_snapshot              => $auto_snapshot,
        multithreaded_compaction   => $multithreaded_compaction,
        endpoint_snitch            => $endpoint_snitch,
        internode_compression      => $internode_compression,
        disk_failure_policy        => $disk_failure_policy,
        thread_stack_size          => $thread_stack_size,

        internode_encryption          => $internode_encryption,
        internode_keystore_location   => $internode_keystore_location,
        internode_keystore_password   => $internode_keystore_password,
        internode_truststore_location => $internode_truststore_location,
        internode_truststore_password => $internode_truststore_password,
                
    }

    include service

    anchor { 'end': }

    Anchor['begin'] -> Class['install'] -> Class['config'] 
    ~> 
    Class['service'] -> Anchor['end']
      
}
