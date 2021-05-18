USE testCollation
GO


SELECT [CodePage] = COLLATIONPROPERTY([name],'CodePage') 
      ,[No. of Collations] = COUNT(*)
FROM sys.fn_helpcollations()
GROUP BY COLLATIONPROPERTY([name],'CodePage')
/*
Code Page = 0 for the collations that support only unicode charactes
*/
SELECT *
FROM  sys.fn_helpcollations()
WHERE COLLATIONPROPERTY([name],'CodePage') = 0;


--example: Try to use an unicode collation on a non-unicode string
DROP TABLE IF EXISTS dbo.TestCodePage
GO
CREATE TABLE dbo.TestCodePage(txt VARCHAR(10)
                                DEFAULT 'AbCd')
GO
--insert sample value
INSERT INTO dbo.TestCodePage 
 DEFAULT VALUES
GO

--attempt to use a collation that supports only unicode
 SELECT txt COLLATE Tibetan_100_CI_AS 
 FROM dbo.TestCodePage
 GO
 /*
 Msg 459, Level 16, State 1, Line 27
 Collation 'Tibetan_100_CI_AS' is supported on Unicode data types only and cannot be applied to char, varchar or text data types.
 */

--use a collation that supports non-unicode
 SELECT txt COLLATE Japanese_CS_AS_KS
 FROM dbo.TestCodePage
 GO



