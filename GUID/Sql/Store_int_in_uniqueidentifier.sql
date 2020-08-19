DECLARE @aBigintNo BIGINT =   123456789987654321;     
/*
For the demonstration we can use, say the maximum positive bigint number
SET @aBigintNo =  -1* (POWER(CAST (-2 AS BIGINT),63) +1)
*/

DECLARE @binary16 BINARY(16)
       ,@guid UNIQUEIDENTIFIER

SET @binary16 = @aBigintNo
SET @guid = @binary16 --implicit conversion bigint to uniqueidentifier is not permitted

SELECT [decimal] = @aBigintNo
      ,[binary(16)] = @binary16
      ,[GUID] = @guid;
GO
