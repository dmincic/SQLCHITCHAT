
/*
Set up SSMS to return results to File (CTRL+SHIFT+F)

1. Run the code with database collation set to Cyrillic_General_CI_AI and save the file Cyrillic.rpt 
2. Run the code with database collation set to Greek_CI_AI  and save the file Greek.rpt 
3. Uncomment the final SELECT statement to get the Unicode characters and save the file Unicode.rpt 
         SELECT TOP(256) [Character] = NCHAR(Num)  --converts a code point into an Unicode character
                        ,[Unicode] = Num
   NOTE: In this case, database collation is not relevant (can stay set up as Greek_CI_AI or Cyrillic_General_CI_AI or any other)

4. Use a file comparison tool to compare the three outputs (I used WinMerge https://winmerge.org/downloads/?lang=en )
*/

IF DB_ID('testCollation') IS NULL   
    CREATE DATABASE testCollation
GO

USE master
go

--In case we decide to run the three scenarios in three separate SSMS sessions
ALTER DATABASE testCollation 
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE
GO

ALTER DATABASE testCollation
    COLLATE Cyrillic_General_CI_AI 
    --COLLATE Greek_CI_AI 
GO

--check the code page
/*
SELECT  codePage_Cyrillic_General_CI_AI = COLLATIONPROPERTY('Cyrillic_General_CI_AI','CodePage')
       ,codePage_Greek_CI_AI = COLLATIONPROPERTY('Greek_CI_AI','CodePage')
GO
*/
USE testCollation
go

--generate some numbers
;WITH N1 AS (SELECT N1.n FROM (VALUES (1),(1),(1),(1),(1),(1),(1),(1),(1),(1)) AS N1 (n))
        ,N2 AS (SELECT L.n FROM N1 AS L CROSS JOIN N1 AS R)
        ,N3 AS (SELECT L.n FROM N2 AS L CROSS JOIN N2 AS R)
        ,N4 AS (SELECT L.n FROM N3 AS L CROSS JOIN N3 AS R)
        ,N5 AS (SELECT L.n FROM N4 AS L CROSS JOIN N4 AS R)
        ,Numbers AS 
        (
            SELECT ROW_NUMBER() OVER (ORDER BY (SELECT null))-1 AS Num FROM N5  --numbers from 0 - 255
        )
         SELECT TOP(256) [Character] = CHAR(Num) --converts a code point into a non-unicode character
                        ,[Code Point] = Num     
         --SELECT TOP(256) [Character] = NCHAR(Num)  --converts a code point into an unicode character
         --               ,[Unicode] = Num
         FROM Numbers
         ORDER BY Num ASC 
GO

USE master
go
ALTER DATABASE testCollation 
    SET MULTI_USER WITH ROLLBACK IMMEDIATE
go