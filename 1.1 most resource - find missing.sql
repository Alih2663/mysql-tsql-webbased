USE BikeStores;
GO
SELECT TOP 20
    qs.execution_count,
    qs.total_elapsed_time / 1000000.0 AS total_elapsed_time_seconds,
    qs.total_worker_time / 1000000.0 AS total_cpu_time_seconds,
    qs.total_logical_reads,
    qs.total_logical_writes,
    SUBSTRING(st.text, (qs.statement_start_offset/2) + 1,
        ((CASE qs.statement_end_offset
            WHEN -1 THEN DATALENGTH(st.text)
            ELSE qs.statement_end_offset
         END - qs.statement_start_offset)/2) + 1) AS statement_text,
    qp.query_plan
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) AS qp
ORDER BY qs.total_elapsed_time DESC;

USE BikeStores;
GO
SELECT
    d.database_id,
    d.object_id,
    OBJECT_NAME(d.object_id, d.database_id) AS TableName,
    d.index_handle,
    d.equality_columns,
    d.inequality_columns,
    d.included_columns,
    gs.avg_total_user_cost,
    gs.avg_user_impact,
    gs.user_seeks,
    gs.user_scans
FROM sys.dm_db_missing_index_group_stats AS gs
INNER JOIN sys.dm_db_missing_index_groups AS g ON gs.group_handle = g.index_group_handle
INNER JOIN sys.dm_db_missing_index_details AS d ON g.index_handle = d.index_handle
WHERE d.database_id = DB_ID('BikeStores')
ORDER BY gs.avg_user_impact DESC;