SELECT TOP 100 -- en yeni 100 bakcup goster
    bs.database_name AS BikeStores,
    CASE bs.type
        WHEN 'D' THEN 'Database Full'
        WHEN 'I' THEN 'Differential'
        WHEN 'L' THEN 'Log'
        WHEN 'F' THEN 'File/Filegroup'
        WHEN 'G' THEN 'Differential File'
        WHEN 'P' THEN 'Partial'
        WHEN 'Q' THEN 'Differential Partial'
        ELSE 'Other (' + bs.type + ')'
    END AS BackupType,
    bs.backup_start_date AS StartTime,
    bs.backup_finish_date AS FinishTime,
    CAST(bs.backup_size / 1024.0 / 1024.0 AS DECIMAL(10, 2)) AS BackupSizeMB,
    bmf.physical_device_name AS BackupFileLocation,
    bs.user_name AS BackupUser,
    CASE bmf.device_type
        WHEN 2 THEN 'Disk'
        WHEN 5 THEN 'Tape'
        WHEN 7 THEN 'Virtual Device'
        ELSE 'Other'
    END AS DeviceType
FROM
    msdb.dbo.backupset bs
INNER JOIN
    msdb.dbo.backupmediafamily bmf ON bs.media_set_id = bmf.media_set_id
WHERE
    bs.database_name = 'BikeStores' -- databese e gore filtre
ORDER BY
    bs.backup_finish_date DESC; -- en yeni backupi goster

GO

--basarisiz yedekleme sonrasi bildirim

DECLARE @Subject NVARCHAR(255);
DECLARE @Body NVARCHAR(MAX);
DECLARE @Query NVARCHAR(MAX);

SET @Subject = N'Backup History Report for BikeStores - ' + CONVERT(VARCHAR, GETDATE(), 120);

SET @Query = N'
SELECT TOP 100
    bs.database_name AS DatabaseName,
    CASE bs.type WHEN ''D'' THEN ''Full'' WHEN ''I'' THEN ''Diff'' WHEN ''L'' THEN ''Log'' ELSE bs.type END AS BackupType,
    bs.backup_start_date AS StartTime,
    bs.backup_finish_date AS FinishTime,
    CAST(bs.backup_size / 1024.0 / 1024.0 AS DECIMAL(10, 2)) AS BackupSizeMB,
    bmf.physical_device_name AS BackupFileLocation
FROM
    msdb.dbo.backupset bs
INNER JOIN
    msdb.dbo.backupmediafamily bmf ON bs.media_set_id = bmf.media_set_id
WHERE
    bs.database_name = ''BikeStores''
ORDER BY
    bs.backup_finish_date DESC;
';

-- calistir ve sonuclari mail oalrak gonder
EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'YourMailProfile',
    @recipients = 'recipient@example.com',
    @subject = @Subject,
    @query = @Query,
    @execute_query_database = 'msdb',
    @attach_query_result_as_file = 1, -- sonuclari maile ekle
    @query_result_header = 1,
    @query_result_width = 256,
    @query_result_separator = ' | ';

GO