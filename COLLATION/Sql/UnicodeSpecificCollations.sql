/* ------------------------------------------------
   Unicode specific collations and non-Unicode data
   Example 1: non-Unicode local variable
   ------------------------------------------------
*/

USE master
GO
/*Attempt to set a Unicode specific collation on a database level*/
ALTER DATABASE testCollation
    COLLATE  Assamese_100_CI_AS_SC; -- a Unicode specific collation
GO
/*
Msg 453, Level 16, State 2, Line 15
Collation 'Assamese_100_CI_AS_SC' is supported on Unicode data types only 
and cannot be set at the database or server level.
*/

USE master
GO
ALTER DATABASE testCollation
    COLLATE  Latin1_General_100_CS_AS; --use a "regular" database default collation
GO

USE testCollation
GO

DECLARE @myNonUnicodeString VARCHAR(20);
SET @myNonUnicodeString = 'Hello World' COLLATE Assamese_100_CI_AS_SC;
SELECT @myNonUnicodeString;
GO
/*
Msg 459, Level 16, State 1, Line 22
Collation 'Assamese_100_CI_AS_SC' is supported on Unicode data types only 
and cannot be applied to char, varchar, or text data types.

However, we can apply the collation on a Unicode string(N'Hello World). The Unicode encoded 
string will be internally converted to a non-Unicode string and stored in(or mapped to) the @myNonUnicodeString
local variable. The database default collation (Latin1_General_100_CS_AS) is automatically assigned to all local variables
of the string type, in this case  @myNonUnicodeString.
It is interesting to see that even if we were able to assign a Unicode specific collation (COLLATE Assamese_100_CI_AS_SC) 
to a Unicode string (N'Hello World'), and then to assign the string value to a local variable that was set up to host non-Unicode values, 
internally,the string value was converted to a non-Unicode encoded value with the database default collation. 
Finally, the @myNonUnicodeString value stores 'Hello World' with the db default collation "Latin1_General_100_CS_AS".


The non-Unicode string value will be automatically Collated by the database default collation, in this case Latin1_General_100_CS_AS
*/
DECLARE @myNonUnicodeString VARCHAR(20);
SET @myNonUnicodeString = N'Hello World' COLLATE Assamese_100_CI_AS_SC;
SELECT @myNonUnicodeString;
GO

/* ------------------------------------------------
   Unicode specific collations and non-Unicode data
   Example 2: non-Unicode table columns
   ------------------------------------------------
*/
USE master
GO
ALTER DATABASE testCollation
    COLLATE  Latin1_General_100_CS_AS; --use a "regular" database default collation
GO

--example: Try to use an unicode collation on a non-unicode string
DROP TABLE IF EXISTS dbo.TestCodePage
GO
CREATE TABLE dbo.TestCodePage(txt VARCHAR(10) -- uses the database default collation
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

/*
the code below performs the following transformations
1. cast the result column "txt" value from non-Unicode to Unicode with the database default collation
2. assigns a new, Unicode specific collation to the column's result.
*/
  SELECT txt = CAST(txt AS NVARCHAR(10)) COLLATE Tibetan_100_CI_AS 
 FROM dbo.TestCodePage
 GO

--use a collation that supports non-unicode
 SELECT txt COLLATE Japanese_CS_AS_KS
 FROM dbo.TestCodePage
 GO
