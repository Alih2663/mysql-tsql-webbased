BEGIN TRANSACTION;

USE BikeStores;
GO
SELECT
    OBJECT_SCHEMA_NAME(s.object_id) AS SchemaName,
    OBJECT_NAME(s.object_id) AS TableName,
    i.name AS IndexName,
    s.user_seeks,
    s.user_scans,
    s.user_lookups,
    s.user_updates
FROM sys.dm_db_index_usage_stats AS s
INNER JOIN sys.indexes AS i ON s.object_id = i.object_id AND s.index_id = i.index_id
WHERE s.database_id = DB_ID('BikeStores')
  AND OBJECTPROPERTY(s.object_id, 'IsUserTable') = 1
  AND i.type_desc != 'HEAP'
  AND s.user_seeks = 0 AND s.user_scans = 0 AND s.user_lookups = 0
  AND i.is_primary_key = 0 AND i.is_unique_constraint = 0 -- Exclude PK/UC supporting indexes
ORDER BY s.user_updates DESC;

-- Example: Creating a non-clustered index on sales.orders for customer_id and order_date
USE BikeStores;
GO
CREATE NONCLUSTERED INDEX IX_orders_customer_date
ON sales.orders (customer_id ASC, order_date DESC)
INCLUDE (store_id, staff_id);

-- First, create a sample index to drop if one doesn't exist for demonstration
-- CREATE INDEX IX_products_model_year_temp ON production.products (model_year);
-- GO
USE BikeStores;
GO
DROP INDEX IF EXISTS IX_products_model_year_temp ON production.products;