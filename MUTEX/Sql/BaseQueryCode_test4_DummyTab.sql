WAITFOR TIME '16:21:10';

    SET XACT_ABORT ON;
 
    DECLARE @spId VARCHAR(1000) = '66,65';

    DECLARE @ShipperId INTEGER
           ,@IdentifierValue VARCHAR(250);
     
    SET @ShipperId = 50009;
    SET @IdentifierValue = 4; -- add a new IdentifierValue
 
    BEGIN TRANSACTION SerializeCode
        SELECT LockMe = COUNT(*) FROM dbo.DummyLock WITH(TABLOCKX); --exclusive table lock

        SELECT * FROM dbo.itvfCheckLocks(@spId) --get metadata
        IF NOT EXISTS ( 
                        SELECT 1
                        FROM   dbo.ShipperIdentifier
                        WHERE  ShipperId = @ShipperId
                            AND IdentifierValue = @IdentifierValue
                      )
        BEGIN
            SELECT * FROM dbo.itvfCheckLocks(@spId) --get metadata
            WAITFOR DELAY '00:00:00.10'; --wait 10ms
            INSERT INTO dbo.ShipperIdentifier (
                                        ShipperId
                                       ,IdentifierValue)
                    VALUES (@ShipperId, @IdentifierValue)
 
            SELECT * FROM dbo.itvfCheckLocks(@spId)  --get metadata
        END

    COMMIT TRANSACTION;
