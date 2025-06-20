SELECT DB_NAME(database_id) as DatabaseName, mirroring_state_desc
FROM sys.database_mirroring
WHERE database_id = DB_ID('BikeStores') AND mirroring_guid IS NOT NULL;