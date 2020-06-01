-----------------------------------
---- multi aggregate pivot example
-----------------------------------
;WITH agg1_freight AS 
(
    SELECT Shipcountry
          ,OrderYear
          ,Freight   --1st aggregate
    FROM dbo.Orders_testPivot
), agg2_OrderVal AS 
(
    SELECT Shipcountry
          ,OrderYear
          ,OrderValue  --2nd aggregate
    FROM dbo.Orders_testPivot
),pivot1_agg1 AS
(
   SELECT pvt1.Shipcountry
         ,pvt1.[2020]
         ,pvt1.[2019]
         ,pvt1.[2018]
   FROM agg1_freight
   PIVOT (SUM(Freight)
          FOR OrderYear
          IN ([2018],[2019],[2020])
          ) pvt1
),pivot2_agg2 AS
(
    SELECT p2.Shipcountry
          ,p2.[2020]
          ,p2.[2019]
          ,p2.[2018]
    FROM agg2_OrderVal
    PIVOT(AVG(OrderValue)
          FOR OrderYear
          IN ([2018],[2019],[2020])
          ) p2
)
SELECT pa1.Shipcountry
      ,[Freight (2018)] = pa1.[2018]
      ,[Freight (2019)] = pa1.[2019]
      ,[Freight (2020)] = pa1.[2020]
      ,[Avg Order value (2018)] = pa2.[2018]
      ,[Avg Order value (2019)] = pa2.[2019]
      ,[Avg Order value (2020)] = pa2.[2020]
FROM pivot1_agg1 pa1
INNER JOIN pivot2_agg2 pa2
    ON pa2.Shipcountry = pa1.Shipcountry;