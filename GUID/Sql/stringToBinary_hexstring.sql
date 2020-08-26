DECLARE @guidString CHAR(36) = 'D9DD9BA5-535C-46C3-888E-5961388C089E';
DECLARE @result VARCHAR(72)=''; --stores the final result

;WITH N1(n) AS --generate 6 rows
(
    SELECT 1 UNION ALL SELECT 1 UNION ALL  SELECT 1 UNION ALL
    SELECT 1 UNION ALL SELECT 1 UNION ALL  SELECT 1 
),numbers(n1) AS --use cartasian product (6x6) to get enough rows to match the GUIDs 36 chars
(
    SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) --construct a sequence of numbers 1-36
    FROM N1,N1 a
),getHexAscii AS 
(
SELECT n1
      ,chars = SUBSTRING(@guidString,n1 ,1) --use seq. no. to navigate to the chars to be "extracted"
      ,[ascii] = ASCII(SUBSTRING(@guidString,n1 ,1)) --ascii code of the "extracted" char
      ,hexAscii = FORMAT(ASCII(SUBSTRING(@guidString,n1 ,1)),'X') --the ascii code formated as hex
FROM numbers
)
--consolidate the chars back to a hexstring
SELECT @result += getHexAscii.hexAscii 
FROM getHexAscii
ORDER BY n1 ASC;

SELECT  [GUID_hexString(72chars)] = @result