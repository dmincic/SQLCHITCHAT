/*
Test how NEWSEQUENTIALID() maintains the ever-increasing seq guids:
Consolidate the GUIDS generated in different environments into table DB1.dbo.T1
Finally, sort the guids and demonstrate the sequence

*/
USE master
GO
--================
--Server 1 
--================

-- Sql Instance 1 (Sql Instance 2) -- (Sql Server 2019)
/*
Create DB1 and two tables (t1 and t2)
CREATE DATABASE DB1
GO
*/
DROP TABLE IF EXISTS DB1.dbo.t1, DB1.dbo.t2;
GO
CREATE TABLE DB1.dbo.t1(seqGuid UNIQUEIDENTIFIER 
                    DEFAULT NEWSEQUENTIALID()
                ,[source] VARCHAR(100)
                    DEFAULT 'Server1,Instance1,DB1,Table t1');
GO
CREATE TABLE DB1.dbo.t2(seqGuid UNIQUEIDENTIFIER 
                    DEFAULT NEWSEQUENTIALID()
                ,[source] VARCHAR(100)
                    DEFAULT 'Server1,Instance1,DB1,Table t2');
GO
/*
Create DB2 and table t1
CREATE DATABASE DB2
GO
*/
DROP TABLE IF EXISTS DB2.dbo.t1
go
CREATE TABLE DB2.dbo.t1(seqGuid UNIQUEIDENTIFIER 
                    DEFAULT NEWSEQUENTIALID()
                ,[source] VARCHAR(100)
                    DEFAULT 'Server1,Instance1,DB2,Table t1');
GO

-- Sql Instance 2 (Sql Server 2014)
/*
CREATE DATABASE DB1
Create DB1 and table t1
*/
DROP TABLE IF EXISTS DB1.dbo.t1;
GO
CREATE TABLE DB1.dbo.t1(seqGuid UNIQUEIDENTIFIER 
                    DEFAULT NEWSEQUENTIALID()
                ,[source] VARCHAR(100)
                    DEFAULT 'Server1,Instance2,DB1,Table t1');
GO

--==============================================================
--Server 2 , Dedicated, single instance server(Sql Server 2014)
--==============================================================
/*
Create DB1 and table t1
CREATE DATABASE DB1
*/
DROP TABLE IF EXISTS DB1.dbo.t1;
GO
CREATE TABLE DB1.dbo.t1(seqGuid UNIQUEIDENTIFIER 
                    DEFAULT NEWSEQUENTIALID()
                ,[source] VARCHAR(100)
                    DEFAULT 'Server2,Instance2,DB1,Table t1');
GO

--==========================
-- TEST
--==========================
-- run the insert on Server1, Instance 1
INSERT INTO DB1.dbo.t1  --(1)
    DEFAULT VALUES
GO
INSERT INTO DB2.dbo.t1  --(2)
    DEFAULT VALUES
GO

-- run the insert on Server1, instance 2
-- output the inserted rows into Server1,Instance1,DB1, t1 table for comparison.
/*
INSERT INTO DB1.dbo.t1  --(3)
    DEFAULT VALUES
GO

SELECT '('+QUOTENAME(seqGuid,'''') +','+ QUOTENAME([source],'''') +')'
FROM DB1.dbo.t1
*/
INSERT INTO DB1.dbo.t1 (seqGuid,[source])
    SELECT 'A39BED8D-2C01-EB11-B4AD-D481D7E528F2','Server1,Instance2,DB1,Table t1'
GO

/*
RESTART Server 1 (this will restart instances 1 and 2)
*/

-- run the insert on Server1, Instance 1
INSERT INTO DB1.dbo.t2  --(4)
    DEFAULT VALUES
GO

-- run the insert on Server2
-- output the inserted rows into Server1,Instance1,DB1, t1 table for comparison.
/*
INSERT INTO DB1.dbo.t1  --(5)
    DEFAULT VALUES
GO

SELECT '('+QUOTENAME(seqGuid,'''') +','+ QUOTENAME([source],'''') +')'
FROM DB1.dbo.t1
*/
INSERT INTO DB1.dbo.t1 (seqGuid,[source])
    SELECT '5FC2DA9D-2F01-EB11-80FE-0025B5560B8C','Server2,DB1,Table t1'
GO


-- run the insert on Server1, Instance 1 ,tab1
INSERT INTO DB1.dbo.t1  --(6)
    DEFAULT VALUES
GO

-------------------------------------
-- sort and compare seq. GUID values 
-------------------------------------
;WITH x AS 
(
    SELECT *
    FROM   DB1.dbo.t1
    UNION
    SELECT *
    FROM   DB1.dbo.t2
    UNION 
      SELECT *
    FROM   DB2.dbo.t1
)
SELECT *
FROM x
ORDER BY x.seqGuid
GO