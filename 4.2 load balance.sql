-- Check AG Health
SELECT
    ag.name AS ag_name,
    ar.replica_server_name,
    drs.synchronization_state_desc,
    drs.is_suspended,
    drs.synchronization_health_desc,
    drs.database_id,
    DB_NAME(drs.database_id) as database_name
FROM sys.availability_groups ag
JOIN sys.availability_replicas ar ON ag.group_id = ar.group_id
JOIN sys.dm_hadr_database_replica_states drs ON ar.replica_id = drs.replica_id
WHERE DB_NAME(drs.database_id) = 'BikeStores'
ORDER BY ag.name, ar.replica_server_name;

-- Check Listener
SELECT agl.dns_name, aglip.ip_address
FROM sys.availability_group_listeners agl
JOIN sys.availability_group_listener_ip_addresses aglip ON agl.listener_id = aglip.listener_id
JOIN sys.availability_groups ag ON agl.group_id = ag.group_id; -- Add joins if needed to filter for AG containing BikeStores