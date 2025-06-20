USE BikeStores;
GO
-- Overall database space for BikeStores
EXEC sp_spaceused;
GO
-- Per file space usage for BikeStores
SELECT
    DB_NAME() AS DbName,
    f.name AS FileName,
    f.physical_name AS PhysicalFileLocation,
    CAST((f.size * 8.0 / 1024) AS DECIMAL(10,2)) AS TotalSizeMB,
    CAST((FILEPROPERTY(f.name, 'SpaceUsed') * 8.0 / 1024) AS DECIMAL(10,2)) AS UsedSpaceMB,
    CAST(((f.size - FILEPROPERTY(f.name, 'SpaceUsed')) * 8.0 / 1024) AS DECIMAL(10,2)) AS FreeSpaceMB,
    f.growth,
    CASE f.is_percent_growth
        WHEN 1 THEN '%'
        ELSE 'MB'
    END AS GrowthType
FROM sys.database_files f;

-- shrinking files code
-- SELECT name, physical_name FROM sys.database_files;
-- GO
-- DBCC SHRINKFILE (N'BikeStores' , 0);
-- DBCC SHRINKFILE (N'BikeStores_Data' , 0);
-- GO
-- DBCC SHRINKDATABASE (N'BikeStores' , 0);