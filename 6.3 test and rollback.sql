--test ve rollback
BACKUP DATABASE BikeStores
TO DISK = 'C:\SQLBackups\BikeStores_PreUpgrade_Demo.bak'
WITH NAME = 'BikeStores Full Backup Before Demo', COMPRESSION, STATS = 10;