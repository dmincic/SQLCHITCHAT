


DROP TABLE IF EXISTS dbo.Products;
GO

CREATE TABLE dbo.Products( ObjectName VARCHAR(255) NOT NULL 
                          ,Attribute VARCHAR(255)
                                PRIMARY KEY(ObjectName,Attribute)
                          ,[Value] SQL_VARIANT)
GO

INSERT INTO dbo.Products (ObjectName,Attribute,[Value])
    SELECT *
    FROM (VALUES ('Seagate BarraCuda','Interface',CAST(CAST('SATA 6Gbps' AS VARCHAR(255)) AS SQL_VARIANT))
                ,('Seagate BarraCuda','Capacity', CAST(CAST('3TB' AS VARCHAR(255)) AS SQL_VARIANT))
                ,('Seagate BarraCuda','Cache'   , CAST(CAST('64MB' AS VARCHAR(255)) AS SQL_VARIANT))
                ,('Seagate BarraCuda','RPM'     , CAST(CAST(7200 AS INTEGER) AS SQL_VARIANT))
                  ---hdd
                ,('WD VelociRaptor','Interface',CAST(CAST('SATA 6Gbps' AS VARCHAR(255)) AS SQL_VARIANT))
                ,('WD VelociRaptor','Capacity', CAST(CAST('1TB' AS VARCHAR(255)) AS SQL_VARIANT))
                ,('WD VelociRaptor','Cache'   , CAST(CAST('64MB' AS VARCHAR(255)) AS SQL_VARIANT))
                ,('WD VelociRaptor','RPM'     , CAST(CAST(10000 AS INTEGER) AS SQL_VARIANT))
                ,('WD VelociRaptor','Average drive ready time', CAST(CAST('8 SECONDS' AS VARCHAR(255)) AS SQL_VARIANT))
                ---tablet
                ,('Lenovo Yoga Tab 3 8','CPU', CAST(CAST('Snapdragon 212' AS VARCHAR(255)) AS SQL_VARIANT))
                ,('Lenovo Yoga Tab 3 8','Camera', CAST(CAST('8 MP' AS VARCHAR(255)) AS SQL_VARIANT))
                ,('Lenovo Yoga Tab 3 8','Battery capacity', CAST(CAST('6200 mAh' AS VARCHAR(255)) AS SQL_VARIANT))
                ,('Lenovo Yoga Tab 3 8','Display', CAST(CAST('8.0" (20.32 cm)' AS VARCHAR(255)) AS SQL_VARIANT))
                --wall mounted owen
                ,('Ariston FK617XAUS','Size', CAST(CAST('60cm' AS VARCHAR(255)) AS SQL_VARIANT))
                ,('Ariston FK617XAUS','Colour', CAST(CAST('Stainless Steel' AS VARCHAR(255)) AS SQL_VARIANT))
                ,('Ariston FK617XAUS','Capacity', CAST(CAST('66L' AS VARCHAR(255)) AS SQL_VARIANT))
                ,('Ariston FK617XAUS','Height', CAST(CAST(60 AS DECIMAL(5,2)) AS SQL_VARIANT))
                ,('Ariston FK617XAUS','Width', CAST(CAST(58.6 AS DECIMAL(5,2)) AS SQL_VARIANT))
                ,('Ariston FK617XAUS','Depth', CAST(CAST(57.99 AS DECIMAL(5,2)) AS SQL_VARIANT))
                --bike
                ,('BMC Road Bike','Frame material', CAST(CAST('Titanium' AS VARCHAR(255)) AS SQL_VARIANT))
                ,('BMC Road Bike','Date manufactured', CAST(CAST('20200101' AS DATE) AS SQL_VARIANT))
                ,('BMC Road Bike','Breaks', CAST(CAST('Disc breaks' AS VARCHAR(255)) AS SQL_VARIANT))

        ) tab(Entity,Attribute,[Value]);
    GO


