
/*
SQL Server instance default collation is SQL_Latin1_General_CP1_CI_AS.
We can change the collation during the installation.
*/

USE master
GO

--Close all active connections to testCollation(e.g intellisence tools etc) db and allow only this connection
--this is to allow the following alter db.
ALTER DATABASE testCollation 
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE
GO

ALTER DATABASE testCollation
    COLLATE SQL_Latin1_General_CP1_CI_AS;
  --COLLATE Latin1_General_100_CI_AS_SC; --windows collation
;
GO

ALTER DATABASE testCollation 
    SET MULTI_USER;
GO

USE testCollation
GO

DROP TABLE IF EXISTS #TEST
GO

CREATE TABLE #TEST (Name_unicode NVARCHAR(50)   COLLATE DATABASE_DEFAULT
                   ,Name_nonUnicode VARCHAR(50) COLLATE DATABASE_DEFAULT
)

INSERT INTO #TEST(Name_unicode,Name_nonUnicode)
    SELECT *
    FROM (VALUES (N'Mountain Bike CG200', 'Mountain Bike CG200')
                ,(N'Mountain Bike C-B200', 'Mountain Bike C-B200')
                ,(N'Mountain Bike A-F100', 'Mountain Bike A-F100')
                ,(N'Mountain Bike ABC', 'Mountain Bike ABC')
                ,(N'Mountain Bike CA12', 'Mountain Bike CA12')) AS TAB(uni,nonuni)

 --SQL and Windows collation use the same algorithim to sort Unicode characters
SELECT Name_unicode
FROM #TEST
ORDER BY Name_unicode;
GO

--SQL Collations use different sorting algorithm when operate on the non-Unicode strings
--Windows collation use the same sorting algorithm for sorting  the Unicode and non-Unicode strings.
SELECT Name_nonUnicode
FROM #TEST
ORDER BY Name_nonUnicode;
GO

