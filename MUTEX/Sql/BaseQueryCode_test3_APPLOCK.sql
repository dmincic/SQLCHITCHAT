WAITFOR TIME '09:45:15'
	SET XACT_ABORT ON;
 
    DECLARE @spId VARCHAR(1000) = '56,54';
    DECLARE @appLckRet INT; --app lock system stored proc return value 
    DECLARE @ShipperId INTEGER
           ,@IdentifierValue VARCHAR(250);
     
    SET @ShipperId = 50009;
    SET @IdentifierValue = '4'; -- add a new IdentifierValue
 
    BEGIN TRANSACTION SerializeCode
    EXEC @appLckRet = sys.sp_getapplock 
             @Resource = N'NewShipperIdenfier'     
            ,@LockMode = 'Exclusive'     
            ,@LockOwner = 'Transaction'    
            ,@LockTimeout = 1500 --ms 
    
        --show the applock status
        SELECT AppLockStatus =  CASE @appLckRet
                                    WHEN 0    THEN 'The lock was successfully granted synchronously'
                                    WHEN 1    THEN 'The lock was granted successfully after waiting for other incompatible locks to be released'
                                    WHEN -1   THEN 'The lock request timed out'
                                    WHEN -2   THEN 'The lock request was canceled'
                                    WHEN -3   THEN 'The lock request was chosen as a deadlock victim'
                                    WHEN -999 THEN 'A parameter validation or other call error'
                                    ELSE 'Have no idea what just happened'
                                END 

        IF @appLckRet >= 0 --successfully granted
        BEGIN 

            SELECT * FROM dbo.itvfCheckLocks(@spId) ORDER BY RequestStartTime --check metadata
            IF NOT EXISTS ( SELECT 1
                            FROM   dbo.ShipperIdentifier 
                            WHERE  ShipperId = @ShipperId
                                AND IdentifierValue = @IdentifierValue
                          )
            BEGIN
                WAITFOR DELAY '00:00:00.10';
                INSERT INTO dbo.ShipperIdentifier (
                                            ShipperId
                                           ,IdentifierValue)
                        VALUES (@ShipperId, @IdentifierValue)
 
                SELECT * FROM dbo.itvfCheckLocks(@spId) ORDER BY RequestStartTime --check metadata
            END
        END 
 
       /*The code below is redundant since it is not necessary to explicitly 
         release Application locks owned by a Transaction. The locks will be automatically 
         released upon the transaction's end.
       */
       IF @appLckRet >= 0
       BEGIN 
            EXEC @appLckRet = sys.sp_releaseapplock        
                 @Resource = N'NewShipperIdenfier'      
                ,@LockOwner = 'Transaction';  
                            
            SELECT AppLockStatus = CASE @appLckRet
                                        WHEN 0      THEN 'Lock was successfully released'
                                        WHEN -999   THEN 'Parameter validation or other call error'
                                        ELSE 'Have no idea what just happened'
                                   END 
       END 

  COMMIT TRANSACTION;