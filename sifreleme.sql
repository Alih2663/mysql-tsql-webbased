--master db'de master key yaratma
USE master;
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '123456789';
GO

--master db'de sertifika yaratma
CREATE CERTIFICATE sertifikam
WITH SUBJECT = 'Certificate for TDE';
GO

--mevcut db'de sifreleme key'i yaratma
USE BikeStores;
GO

CREATE DATABASE ENCRYPTION KEY WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE sertifikam;
GO

ALTER DATABASE BikeStores
SET ENCRYPTION ON;
GO

--kontrol
SELECT
    db.name AS BikeStores,
    db.is_encrypted,
    dm.encryption_state,
    dm.percent_complete
FROM
    sys.databases db
LEFT JOIN
    sys.dm_database_encryption_keys dm
ON db.database_id = dm.database_id
WHERE db.name = 'BikeStores';
GO

--yedek master key
USE master;
GO
BACKUP MASTER KEY TO FILE = 'C:\Temp\MasterKeyBackup.key'
ENCRYPTION BY PASSWORD = '987654321';
GO

--yedek sertifika
USE master;
GO
BACKUP CERTIFICATE sertifikam TO FILE = 'C:\Temp\sertifikam.cer'
WITH PRIVATE KEY (
    FILE = 'C:\Temp\sertifikam_PrivateKey.pvk',
    ENCRYPTION BY PASSWORD = '741852963'
);
GO