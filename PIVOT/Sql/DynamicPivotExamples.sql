 -----------------------
 -- dynamic pivot  Ver.1
------------------------
DECLARE @sprdElements AS NVARCHAR(MAX) -- comma separated, delimited, distinct list of product attributes
        ,@tSql AS NVARCHAR(MAX)        -- query text
        ,@ObjectName VARCHAR(255);     -- specific product name

SET @ObjectName = 'BMC Road Bike' --specific product (Use NULL value to get all products)

--comma separated list of attributes for a product
;WITH dsitSpreadElList AS
(
    SELECT DISTINCT Attribute
    FROM Products
    WHERE ObjectName = @ObjectName
        OR @ObjectName IS NULL
)
SELECT @sprdElements = COALESCE(@sprdElements+', ','')+'['+ CAST( Attribute AS NVARCHAR(255))+']'
--SELECT @sprdElements = STRING_AGG('['+Attribute+']',',') --available in SQL2017+
FROM dsitSpreadElList;

--print @sprdElements

SET @tSql =N';WITH TabExp AS
             (
                SELECT ObjectName -- grouping element
                      ,Attribute  -- spreading element
                      ,[Value]    -- aggregating element
                FROM dbo.Products
                WHERE ObjectName = @ObjName
                  OR @ObjName IS NULL
	         )
             SELECT ObjectName,'+@sprdElements +N'
             FROM TabExp
             PIVOT (
                    MAX([Value])
                    FOR Attribute IN (' + @sprdElements +N') 
                    ) AS pvt';

 EXEC sys.sp_executesql
     @stmt = @tSql
    ,@params = N'@ObjName VARCHAR(255)'
    ,@ObjName = @ObjectName;

GO
 -----------------------
 -- dynamic pivot  Ver.2
------------------------
DECLARE @sprdElements AS NVARCHAR(MAX)  --comma separated, delimited, distinct list of product attributes
        ,@tSql AS NVARCHAR(MAX)         --query text
        ,@ObjectName VARCHAR(255);      --specific product name

SET @ObjectName = 'BMC Road Bike' --specific product (Use NULL value to get all products)


 SET @tSql = N' SELECT *
                FROM (
                       SELECT ObjectName
                              ,Attribute
                              ,[Value]
                       FROM dbo.Products
                       WHERE ObjectName = @ObjName
                          OR @ObjName IS NULL
                     ) AS prod
                PIVOT(
                      MAX([Value]) 
                      FOR Attribute 
                      IN(' + STUFF(
                                    (
                                    SELECT N',' + QUOTENAME(Attribute) AS [text()]
                                    FROM ( 
                                            SELECT DISTINCT Attribute 
                                            FROM dbo.Products
                                            WHERE ObjectName = @ObjectName
                                                OR @ObjectName IS NULL 
                                            ) AS prod
                                    FOR XML PATH('')
                                    ), 1, 1, ''
                                ) + N')) AS P;';

 EXEC sys.sp_executesql
     @stmt = @tSql
    ,@params = N'@ObjName VARCHAR(255)'
    ,@ObjName = @ObjectName;
GO
