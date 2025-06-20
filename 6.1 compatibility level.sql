-- guncel seviye kontrol
SELECT compatibility_level FROM sys.databases WHERE name = 'BikeStores';

-- seviye atamasi
ALTER DATABASE BikeStores SET COMPATIBILITY_LEVEL = 150;
GO
-- kontrol
SELECT compatibility_level FROM sys.databases WHERE name = 'BikeStores';