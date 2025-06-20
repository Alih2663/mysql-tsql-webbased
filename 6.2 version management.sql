USE BikeStores;
GO

--sema loglariyla table olusturma
IF OBJECT_ID('dbo.SchemaChangeLog', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.SchemaChangeLog (
        LogID INT IDENTITY(1,1) PRIMARY KEY,
        EventTime DATETIME2 DEFAULT GETDATE(),
        LoginName SYSNAME,
        EventType SYSNAME,
        ObjectType SYSNAME,
        SchemaName SYSNAME,
        ObjectName SYSNAME,
        TSQLCommand NVARCHAR(MAX),
        EventData XML
    );
END

-- ddl trigger yaratma
USE BikeStores;
GO
IF OBJECT_ID('TR_BikeStores_SchemaChangeAudit', 'TR') IS NOT NULL
    DROP TRIGGER TR_BikeStores_SchemaChangeAudit ON DATABASE;
GO
CREATE TRIGGER TR_BikeStores_SchemaChangeAudit
ON DATABASE
FOR DDL_DATABASE_LEVEL_EVENTS
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @eventData XML = EVENTDATA();
    INSERT INTO dbo.SchemaChangeLog (
        LoginName, EventType, ObjectType, SchemaName, ObjectName, TSQLCommand, EventData
    )
    VALUES (
        SUSER_SNAME(),
        @eventData.value('(/EVENT_INSTANCE/EventType)[1]', 'SYSNAME'),
        @eventData.value('(/EVENT_INSTANCE/ObjectType)[1]', 'SYSNAME'),
        @eventData.value('(/EVENT_INSTANCE/SchemaName)[1]', 'SYSNAME'),
        @eventData.value('(/EVENT_INSTANCE/ObjectName)[1]', 'SYSNAME'),
        @eventData.value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'NVARCHAR(MAX)'),
        @eventData
    );
END;
GO

--test
USE BikeStores;
GO
CREATE TABLE dbo.TestTableForDDLDemo (ID INT);
GO
ALTER TABLE dbo.TestTableForDDLDemo ADD NewColumn VARCHAR(10);
GO
DROP TABLE dbo.TestTableForDDLDemo;
GO

--log
USE BikeStores;
GO
SELECT * FROM dbo.SchemaChangeLog ORDER BY EventTime DESC;