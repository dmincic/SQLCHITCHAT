WAITFOR TIME '13:58:40';

    SET XACT_ABORT ON;
 
    DECLARE @spId VARCHAR(1000) = '66,65';
    DECLARE @i INT =0; --loop iteration indicator

    DECLARE @ShipperId INTEGER
           ,@IdentifierValue VARCHAR(250);
     
    SET @ShipperId = 50009;
    SET @IdentifierValue = 4; -- add a new IdentifierValue

WHILE(1 = 1)
BEGIN 
    IF OBJECT_ID('dbo.LockCodeSection','U') IS NULL
    BEGIN
        BEGIN TRY 
            CREATE TABLE dbo.LockCodeSection(LockMe BIT)
 
            BEGIN TRANSACTION SerializeCode           
                IF NOT EXISTS ( 
                                SELECT 1
                                FROM   dbo.ShipperIdentifier
                                WHERE  ShipperId = @ShipperId
                                    AND IdentifierValue = @IdentifierValue
                              )
                BEGIN
                    WAITFOR DELAY '00:00:00.10'; --wait 10ms
                    INSERT INTO dbo.ShipperIdentifier (
                                                ShipperId
                                               ,IdentifierValue)
                            VALUES (@ShipperId, @IdentifierValue)

                    SELECT [And the winner is..] ='Session: '+CAST(@@SPID AS VARCHAR(10))
                END    
            COMMIT TRANSACTION;

            DROP TABLE dbo.LockCodeSection
            BREAK;
        END TRY 
      
        BEGIN CATCH
            IF @@TRANCOUNT > 0 
                ROLLBACK TRANSACTION;

            IF OBJECT_ID('dbo.LockCodeSection','U') IS NOT NULL
                DROP TABLE dbo.LockCodeSection;

            THROW;
        END CATCH     
    END --end if branch
    
    SET @i+=1;
END --end loop

SELECT NoOfLoops = @i , [Session]=@@SPID

