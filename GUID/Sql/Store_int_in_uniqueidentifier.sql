DECLARE @BigNumeric DECIMAL(28,0) = 1234567898765321234567898765;   
/*
For the demonstration I used a positive integer that requires more than 8bytes of space 
*/

DECLARE @binary16 BINARY(16)
       ,@guid UNIQUEIDENTIFIER

SET @binary16 = @BigNumeric
SET @guid = @binary16 --implicit conversion from a numeric to uniqueidentifier is not permitted

SELECT [decimal] = @BigNumeric
      ,[binary(16)] = @binary16
      ,[GUID] = @guid;

--to convert back to numberic
/*
SELECT CONVERT(DECIMAL(28,0), @binary16) --bin -> numberic
SELECT CONVERT(DECIMAL(28,0),CONVERT(BINARY(16), @guid)) --guid -> bin -> numeric
*/
GO