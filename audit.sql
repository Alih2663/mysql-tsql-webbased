-- log dosyalari olusturmak icin audit yaratir
USE master;
GO
CREATE SERVER AUDIT auditim
TO FILE
(   FILEPATH = 'C:\audits\logs\' ,
    MAXSIZE = 100 MB,
    MAX_FILES = 5,
    RESERVE_DISK_SPACE = OFF
)
WITH (QUEUE_DELAY = 1000, ON_FAILURE = CONTINUE);
GO

USE master;
GO
CREATE SERVER AUDIT SPECIFICATION auditOzelliklerim
FOR SERVER AUDIT auditim
ADD (FAILED_LOGIN_GROUP),       -- basarisiz giris
ADD (SUCCESSFUL_LOGIN_GROUP),   -- basarili giris
ADD (SERVER_PRINCIPAL_CHANGE_GROUP), -- rol degisimi
ADD (DATABASE_CHANGE_GROUP)     -- db degisiklikleri
WITH (STATE = OFF);
GO

-- db degisikleri auditleri olusturma
USE BikeStores;
GO
CREATE DATABASE AUDIT SPECIFICATION scopeAuditiOzelliklerim
FOR SERVER AUDIT auditim
ADD (SELECT ON OBJECT::dbo.production.stocks BY public), -- table a erisim yapanlar
ADD (INSERT ON OBJECT::dbo.production.stocks BY YourUserOrRoleName), -- insert yapanlar
ADD (DELETE ON SCHEMA::dbo BY YourUserOrRoleName), -- delete yapanlar
ADD (EXECUTE ON OBJECT::dbo.YourStoredProcedure BY public) -- execute yapanlar
WITH (STATE = OFF);
GO

-- server audit acma
ALTER SERVER AUDIT auditim
WITH (STATE = ON);
GO

-- server audit ozellikleri
ALTER SERVER AUDIT SPECIFICATION auditOzelliklerim
WITH (STATE = ON);
GO

-- spesifik db de audit ozellikleri
USE BikeStores;
GO
ALTER DATABASE AUDIT SPECIFICATION scopeAuditiOzelliklerim
WITH (STATE = ON);
GO

SELECT *
FROM sys.fn_get_audit_file (
    'C:\audits\logs\*.sqlaudit',
    DEFAULT, DEFAULT
);
GO