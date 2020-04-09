
/*
USE TestDB
GO
*/
--create test table
DROP TABLE IF EXISTS dbo.Employees;
GO
CREATE TABLE dbo.Employees(
        EmpId INT NOT NULL
          CONSTRAINT PK_EmpId PRIMARY KEY,
        MgrId INT NULL
          CONSTRAINT FK_MgrId_EmpId  REFERENCES dbo.Employees(EmpId) --self reference
        ,CHECK (EmpId != MgrId)
)
GO

--insert test data
INSERT INTO dbo.Employees(EmpId,MgrId)
    SELECT TAB.Emp,TAB.Mgr
    FROM (VALUES (1,NULL)
                ,(2,1)
                ,(3,1)
                ,(4,1)
                ,(5,2)
                ,(6,2)
                ,(7,3)
                ,(8,3)
                ,(9,3)
                ,(10,8)
                ,(11,8)
                ,(12,10)) TAB(Emp,Mgr);        
GO
--check data
SELECT * FROM dbo.Employees;