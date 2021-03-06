
DROP TABLE IF EXISTS dbo.Orders_testPivot
GO

CREATE TABLE dbo.Orders_testPivot(
        Orderid INT NOT NULL IDENTITY(1, 1)
            PRIMARY KEY CLUSTERED,
        Custid      INT       NULL,
        Orderdate   DATETIME  NOT NULL,
        OrderYear   AS YEAR(Orderdate) PERSISTED,  
        Shipperid   INT       NOT NULL,
        OrderValue  DECIMAL(38,6)  NOT NULL,
        Freight     MONEY     NOT NULL,
        Shipname    NVARCHAR(40) NOT NULL,
        Shipaddress NVARCHAR(60) NOT NULL,
        Shipcity    NVARCHAR(15) NOT NULL,
        Shipregion  NVARCHAR(15) NULL,
        Shipcountry     NVARCHAR(15) NOT NULL
);
GO

SET IDENTITY_INSERT dbo.Orders_testPivot ON 
    INSERT INTO dbo.Orders_testPivot (
         Orderid
        ,Custid
        ,Orderdate 
        ,Shipperid
        ,Freight
        ,OrderValue
        ,Shipname
        ,Shipaddress
        ,Shipcity
        ,Shipregion
        ,Shipcountry
)
SELECT *
FROM (
 VALUES (10298,37,'2018-09-05',2,168.22,'3127.00','Destination ATSOA','4567 Johnstown Road','Cork','Co. Cork','Ireland'),
        (10309,37,'2018-09-19',1,47.30,'1762.00','Destination ATSOA','4567 Johnstown Road','Cork','Co. Cork','Ireland'),
        (10332,51,'2018-10-17',2,52.84,'2233.60','Ship to 51-B','7890 rue St. Laurent','Montr�al','Qu�bec','Canada'),
        (10335,37,'2018-10-22',2,42.11,'2545.20','Destination ATSOA','4567 Johnstown Road','Cork','Co. Cork','Ireland'),
        (10339,51,'2018-10-28',2,15.66,'3463.20','Ship to 51-C','8901 rue St. Laurent','Montr�al','Qu�bec','Canada'),
        (10373,37,'2018-12-05',3,124.12,'1708.00','Destination KPVYJ','5678 Johnstown Road','Cork','Co. Cork','Ireland'),
        (10376,51,'2018-12-09',2,20.39,'420.00','Ship to 51-B','7890 rue St. Laurent','Montr�al','Qu�bec','Canada'),
        (10380,37,'2018-12-12',3,35.03,'1419.80','Destination KPVYJ','5678 Johnstown Road','Cork','Co. Cork','Ireland'),
        (10387,70,'2018-12-18',2,93.63,'1058.40','Ship to 70-B','Erling Skakkes gate 5678','Stavern','NULL','Norway'),
        (10389,10,'2018-12-20',2,47.42,'1832.80','Destination OLSSJ','2345 Tsawassen Blvd.','Tsawassen','BC','Canada'),
        (10409,54,'2019-01-09',1,29.83,'319.20','Ship to 54-C','Ing. Gustavo Moncada 6789 Piso 20-A','Buenos Aires','NULL','Argentina'),
        (10410,10,'2019-01-10',3,2.40,'802.00','Destination OLSSJ','2345 Tsawassen Blvd.','Tsawassen','BC','Canada'),
        (10411,10,'2019-01-10',3,23.65,'1208.50','Destination XJIBQ','1234 Tsawassen Blvd.','Tsawassen','BC','Canada'),
        (10424,51,'2019-01-23',2,370.61,'11493.20','Ship to 51-C','8901 rue St. Laurent','Montr�al','Qu�bec','Canada'),
        (10429,37,'2019-01-29',2,56.63,'1748.50','Destination DGKOU','6789 Johnstown Road','Cork','Co. Cork','Ireland'),
        (10431,10,'2019-01-30',2,44.17,'2523.00','Destination OLSSJ','2345 Tsawassen Blvd.','Tsawassen','BC','Canada'),
        (10439,51,'2019-02-07',3,4.07,'1078.00','Ship to 51-C','8901 rue St. Laurent','Montr�al','Qu�bec','Canada'),
        (10448,64,'2019-02-17',2,38.82,'443.40','Ship to 64-A','Av. del Libertador 4567','Buenos Aires','NULL','Argentina'),
        (10492,10,'2019-04-01',1,62.89,'896.00','Destination XJIBQ','1234 Tsawassen Blvd.','Tsawassen','BC','Canada'),
        (10495,42,'2019-04-03',3,4.65,'278.00','Ship to 42-C','2345 Elm St.','Vancouver','BC','Canada'),
        (10503,37,'2019-04-11',2,16.74,'2048.50','Destination ATSOA','4567 Johnstown Road','Cork','Co. Cork','Ireland'),
        (10505,51,'2019-04-14',3,7.13,'147.90','Ship to 51-B','7890 rue St. Laurent','Montr�al','Qu�bec','Canada'),
        (10516,37,'2019-04-24',3,62.78,'2614.50','Destination DGKOU','6789 Johnstown Road','Cork','Co. Cork','Ireland'),
        (10520,70,'2019-04-29',1,13.37,'200.00','Ship to 70-B','Erling Skakkes gate 5678','Stavern','NULL','Norway'),
        (10521,12,'2019-04-29',2,17.22,'225.50','Destination QTHBC','Cerrito 6789','Buenos Aires','NULL','Argentina'),
        (10531,54,'2019-05-08',1,8.12,'110.00','Ship to 54-A','Ing. Gustavo Moncada 4567 Piso 20-A','Buenos Aires','NULL','Argentina'),
        (10565,51,'2019-06-11',2,7.15,'711.00','Ship to 51-C','8901 rue St. Laurent','Montr�al','Qu�bec','Canada'),
        (10567,37,'2019-06-12',1,33.97,'3109.00','Destination DGKOU','6789 Johnstown Road','Cork','Co. Cork','Ireland'),
        (10570,51,'2019-06-17',3,188.99,'2595.00','Ship to 51-C','8901 rue St. Laurent','Montr�al','Qu�bec','Canada'),
        (10590,51,'2019-07-07',3,44.77,'1140.00','Ship to 51-B','7890 rue St. Laurent','Montr�al','Qu�bec','Canada'),
        (10605,51,'2019-07-21',2,379.13,'4326.00','Ship to 51-B','7890 rue St. Laurent','Montr�al','Qu�bec','Canada'),
        (10618,51,'2019-08-01',1,154.68,'2697.50','Ship to 51-C','8901 rue St. Laurent','Montr�al','Qu�bec','Canada'),
        (10619,51,'2019-08-04',3,91.05,'1260.00','Ship to 51-B','7890 rue St. Laurent','Montr�al','Qu�bec','Canada'),
        (10620,42,'2019-08-05',3,0.94,'57.50','Ship to 42-A','1234 Elm St.','Vancouver','BC','Canada'),
        (10639,70,'2019-08-20',3,38.64,'500.00','Ship to 70-B','Erling Skakkes gate 5678','Stavern','NULL','Norway'),
        (10646,37,'2019-08-27',3,142.33,'1928.00','Destination ATSOA','4567 Johnstown Road','Cork','Co. Cork','Ireland'),
        (10661,37,'2019-09-09',3,17.55,'703.25','Destination ATSOA','4567 Johnstown Road','Cork','Co. Cork','Ireland'),
        (10687,37,'2019-09-30',2,296.43,'6201.90','Destination KPVYJ','5678 Johnstown Road','Cork','Co. Cork','Ireland'),
        (10701,37,'2019-10-13',3,220.31,'3370.00','Destination KPVYJ','5678 Johnstown Road','Cork','Co. Cork','Ireland'),
        (10712,37,'2019-10-21',1,89.93,'1238.40','Destination KPVYJ','5678 Johnstown Road','Cork','Co. Cork','Ireland'),
        (10716,64,'2019-10-24',2,22.57,'706.00','Ship to 64-B','Av. del Libertador 5678','Buenos Aires','NULL','Argentina'),
        (10724,51,'2019-10-30',2,57.75,'638.50','Ship to 51-A','6789 rue St. Laurent','Montr�al','Qu�bec','Canada'),
        (10736,37,'2019-11-11',2,44.10,'997.00','Destination DGKOU','6789 Johnstown Road','Cork','Co. Cork','Ireland'),
        (10742,10,'2019-11-14',3,243.73,'3118.00','Destination LPHSI','3456 Tsawassen Blvd.','Tsawassen','BC','Canada'),
        (10782,12,'2019-12-17',3,1.10,'12.50','Destination CJDJB','Cerrito 8901','Buenos Aires','NULL','Argentina'),
        (10810,42,'2020-01-01',3,4.33,'187.00','Ship to 42-A','1234 Elm St.','Vancouver','BC','Canada'),
        (10819,12,'2020-01-07',3,19.76,'477.00','Destination QTHBC','Cerrito 6789','Buenos Aires','NULL','Argentina'),
        (10828,64,'2020-01-13',1,90.85,'932.00','Ship to 64-B','Av. del Libertador 5678','Buenos Aires','NULL','Argentina'),
        (10831,70,'2020-01-14',2,72.19,'2684.40','Ship to 70-B','Erling Skakkes gate 5678','Stavern','NULL','Norway'),
        (10881,12,'2020-02-11',1,2.84,'150.00','Destination IGLOB','Cerrito 7890','Buenos Aires','NULL','Argentina'),
        (10897,37,'2020-02-19',2,603.54,'10835.24','Destination DGKOU','6789 Johnstown Road','Cork','Co. Cork','Ireland'),
        (10898,54,'2020-02-20',2,1.27,'30.00','Ship to 54-B','Ing. Gustavo Moncada 5678 Piso 20-A','Buenos Aires','NULL','Argentina'),
        (10909,70,'2020-02-26',2,53.05,'670.00','Ship to 70-C','Erling Skakkes gate 6789','Stavern','NULL','Norway'),
        (10912,37,'2020-02-26',2,580.91,'8267.40','Destination DGKOU','6789 Johnstown Road','Cork','Co. Cork','Ireland'),
        (10916,64,'2020-02-27',2,63.77,'686.70','Ship to 64-C','Av. del Libertador 6789','Buenos Aires','NULL','Argentina'),
        (10918,10,'2020-03-02',3,48.83,'1930.00','Destination OLSSJ','2345 Tsawassen Blvd.','Tsawassen','BC','Canada'),
        (10937,12,'2020-03-10',3,31.51,'644.80','Destination QTHBC','Cerrito 6789','Buenos Aires','NULL','Argentina'),
        (10944,10,'2020-03-12',3,52.92,'1139.10','Destination XJIBQ','1234 Tsawassen Blvd.','Tsawassen','BC','Canada'),
        (10949,10,'2020-03-13',3,74.44,'4422.00','Destination OLSSJ','2345 Tsawassen Blvd.','Tsawassen','BC','Canada'),
        (10958,54,'2020-03-18',2,49.56,'781.00','Ship to 54-C','Ing. Gustavo Moncada 6789 Piso 20-A','Buenos Aires','NULL','Argentina'),
        (10975,10,'2020-03-25',3,32.27,'717.50','Destination OLSSJ','2345 Tsawassen Blvd.','Tsawassen','BC','Canada'),
        (10982,10,'2020-03-27',1,14.01,'1014.00','Destination XJIBQ','1234 Tsawassen Blvd.','Tsawassen','BC','Canada'),
        (10985,37,'2020-03-30',1,91.51,'2248.20','Destination ATSOA','4567 Johnstown Road','Cork','Co. Cork','Ireland'),
        (10986,54,'2020-03-30',2,217.86,'2220.00','Ship to 54-A','Ing. Gustavo Moncada 4567 Piso 20-A','Buenos Aires','NULL','Argentina'),
        (11015,70,'2020-04-10',2,4.62,'622.35','Ship to 70-C','Erling Skakkes gate 6789','Stavern','NULL','Norway'),
        (11019,64,'2020-04-13',3,3.17,'76.00','Ship to 64-B','Av. del Libertador 5678','Buenos Aires','NULL','Argentina'),
        (11027,10,'2020-04-16',1,52.52,'1170.30','Destination XJIBQ','1234 Tsawassen Blvd.','Tsawassen','BC','Canada'),
        (11045,10,'2020-04-23',2,70.58,'1309.50','Destination LPHSI','3456 Tsawassen Blvd.','Tsawassen','BC','Canada'),
        (11048,10,'2020-04-24',3,24.12,'525.00','Destination XJIBQ','1234 Tsawassen Blvd.','Tsawassen','BC','Canada'),
        (11054,12,'2020-04-28',1,0.33,'305.00','Destination QTHBC','Cerrito 6789','Buenos Aires','NULL','Argentina'),
        (11063,37,'2020-04-30',2,81.73,'1445.50','Destination KPVYJ','5678 Johnstown Road','Cork','Co. Cork','Ireland')
    ) tab(orderid,custid,orderdate,shipperid,freight,ordervalue,shipname,shipaddress,shipcity,shipregion,shipcountry)
SET IDENTITY_INSERT dbo.Orders_testPivot OFF 
GO
