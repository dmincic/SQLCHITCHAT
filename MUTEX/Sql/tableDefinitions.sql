

    /*Create test table*/
    DROP TABLE IF EXISTS dbo.ShipperIdentifier;
    GO
    
    CREATE TABLE dbo.ShipperIdentifier(
                       Id INT IDENTITY(1,1) 
                          CONSTRAINT PK_Id 
                              PRIMARY KEY CLUSTERED
                      ,ShipperId INT NOT NULL
                      ,IdentifierValue INTEGER NOT NULL 
                          CONSTRAINT UC_ShippierId_IdentifierValue 
                              UNIQUE(ShipperId,IdentifierValue)
                      ,[_SpId] INT --used to identify which session inserted record
                           CONSTRAINT DF_SpId 
                              DEFAULT(@@SPID)
    );
    GO

    /*Add some test data*/
    --insert test data (1 ShipperId - 10000 distinct IdentifierValue. - IdentifierValue are the odd numbers from 3 to 20001
    ;WITH N1(C) AS (SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0) -- 4 rows 
         ,N2(C) AS (SELECT 0 FROM N1 AS T1 CROSS JOIN N1 AS T2 )                           -- 16 rows
         ,N3(C) AS (SELECT 0 FROM N2 AS T1 CROSS JOIN N2 AS T2)                            -- 256 rows
         ,N4(C) AS (SELECT 0 FROM N3 AS T1 CROSS JOIN N3 AS T2)                            -- 65536 rows
    ,Id(r) AS --numbers 
    (
      SELECT r  = ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) - 1 --start from zero
      FROM N4
    )
    INSERT INTO dbo.ShipperIdentifier(ShipperId,IdentifierValue,_SpId)
    SELECT TOP(10000)
           ShipperId = 50009
          ,IdentifierValue = (r*2)+1 
          ,InitialInsert = 0 --initial insert 
    FROM Id
    GO

    /*Table used in one of the experiments*/
    DROP TABLE IF EXISTS dbo.DummyLock;
    GO
    CREATE TABLE dbo.DummyLock(LockMe BIT);
    GO
