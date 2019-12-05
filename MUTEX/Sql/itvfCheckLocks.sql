

/*Create ITVF to collect metadata related to the resource locking*/
DROP FUNCTION IF EXISTS dbo.itvfCheckLocks;
GO

CREATE FUNCTION dbo.itvfCheckLocks(
             @spids VARCHAR(1000) ='' --comma separated list of SpIds
)
RETURNS TABLE
AS 
RETURN
     --stripped down version of Aaron Bertrand's SplitString routine
     --https://sqlperformance.com/2012/07/t-sql-queries/split-strings
     WITH splitString AS 
    (
        SELECT TOP(1000) rn = ROW_NUMBER() OVER (ORDER BY( SELECT NULL))
        FROM sys.columns, sys.columns c1, sys.columns c2 
        ORDER BY(SELECT NULL)
    ),cteStart(N1) AS 
    ( 
        SELECT 1
        UNION ALL
        SELECT rn+ 1 
        FROM splitString  
        WHERE SUBSTRING(@spids,rn,1) = ','
    ),cteLen(N1,L1) AS
    (  
        SELECT s.N1 
                ,ISNULL(NULLIF(CHARINDEX(',',@spids,s.N1),0)-s.N1,8000)
        FROM cteStart s
    ),SpidList as 
    (
        SELECT ItemNumber  = ROW_NUMBER() OVER(ORDER BY l.N1)
                ,Spid       = SUBSTRING(@spids, l.N1, l.L1)
        FROM cteLen l 
    )
    SELECT   lck.request_session_id
            ,ObjectName = CASE
                        WHEN lck.resource_type = 'OBJECT'
                            THEN OBJECT_NAME(lck.resource_associated_entity_id)
                        ELSE OBJECT_NAME(p.[object_id])
                    END
            ,IndexName = i.[name]
            ,IndexType = i.[type_desc]
            ,lck.resource_type
            ,lck.resource_description

             ---hardcoded
            ,[%%Id%%]        = unHashLock.Id
            ,[%%ShipperId%%] = unHashLock.ShipperId
            ,[%%IdentifierValue%%] = unHashLock.IdentifierValue
            ,[%%File:Page:Slot%%] =unHashLock.FilePageSlot
             ----
            ,lck.request_mode
            ,lck.request_type
            ,lck.request_status
            ,execr.blocking_session_id   
            ,lck.request_owner_type 

            ,RequestStartTime = execr.start_time
            ,fnExecTime = SYSDATETIME()
            ,execr.total_elapsed_time
    FROM sys.dm_tran_locks lck WITH (NOLOCK)
        INNER JOIN SpidList s  --- requested spids
            ON s.Spid  = lck.request_session_id
        LEFT JOIN sys.partitions p WITH (NOLOCK)
            ON p.hobt_id = lck.resource_associated_entity_id
        LEFT JOIN sys.indexes i WITH (NOLOCK)
            ON i.OBJECT_ID = p.OBJECT_ID AND i.index_id = p.index_id
        LEFT OUTER JOIN sys.dm_exec_requests execr WITH (NOLOCK)
            ON lck.request_session_id = execr.session_id
       --hardcoded
    OUTER APPLY(
                SELECT *,FilePageSlot = sys.fn_PhysLocFormatter(sh.%%physloc%%) 
                FROM dbo.ShipperIdentifier sh WITH (NOLOCK)
                WHERE %%lockres%% = lck.resource_description
            UNION ALL
                SELECT *,FilePageSlot = sys.fn_PhysLocFormatter(sh.%%physloc%%) 
                FROM dbo.ShipperIdentifier sh WITH (INDEX =UC_ShippierId_IdentifierValue,NOLOCK) 
                WHERE %%lockres%% = lck.resource_description
                ) unHashLock
   -----
    WHERE resource_associated_entity_id > 0
        AND resource_database_id = DB_ID()
        AND OBJECT_NAME(p.[object_id]) = N'ShipperIdentifier'
GO

