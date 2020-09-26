

DROP TABLE IF EXISTS dbo.guidOnDdataPage;
GO
CREATE TABLE dbo.guidOnDdataPage(guidUID UNIQUEIDENTIFIER
                                ,guidBIN BINARY(16)
)
GO

DECLARE @BigNumeric DECIMAL(28,0) = 1234567898765321234567898765;   

DECLARE @binary16 BINARY(16)
       ,@guid UNIQUEIDENTIFIER

SET @binary16 = @BigNumeric
SET @guid = @binary16 --implicit conversion from a numeric to uniqueidentifier is not permitted


INSERT INTO dbo.guidOnDdataPage(guidUID,guidBIN)
SELECT [binary(16)] = @binary16
      ,[GUID] = @guid;
GO

--find the data page id which stores the inserted values
SELECT   f.guidUID
        ,f.guidBIN
        ,%%lockres%% as [FileId:PageId:SlotId]
FROM dbo.guidOnDdataPage f 
GO

--in my example, PageId = 32353

--set the DBCC'S output to the screen
DBCC TRACESTATUS(3604) --check the flag's status
GO
DBCC TRACEON(3604) --sets up traceflag 3604 value to true on a session level
GO

SELECT * FROM dbo.guidOnDdataPage
--display the page dump !!!add your pageID here 
DBCC PAGE (0,1,32353,3) --WITH TABLERESULTS
GO

DBCC TRACEOFF(3604) --sets up traceflag 3604 value to true on a session level
GO
