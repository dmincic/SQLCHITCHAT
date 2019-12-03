

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

    SELECT CurrentDateTime = SYSDATETIME()
	      ,lck.resource_type
		  --,DB_NAME(lck.resource_database_id) AS DBName
		  --,ResoruceName = o.name 
		  ,lck.resource_description		
		   ---hardcoded values for a specific table
          ,LockedResourceValues.HashKeyFrom
		  ,LockedResourceValues.Id	
		  ,LockedResourceValues.ShipperId
		  ,LockedResourceValues.IdentifierValue
		  -----------------------------------
          ,lck.request_session_id
		  ,lck.request_mode
		  ,lck.request_type
		  ,lck.request_status		
		  ,execr.blocking_session_id
		  ,lck.request_owner_type
		  
		  --,execr.transaction_isolation_level
		  ,IsolationLevel = CASE execr.transaction_isolation_level
							    WHEN 0 THEN 'Unspecified'
								WHEN 1 THEN 'ReadUncomitted'
								WHEN 2 THEN 'ReadCommitted'
								WHEN 3 THEN 'Repeatable'
								WHEN 4 THEN 'Serializable'
								WHEN 5 THEN 'Snapshot'
								ELSE 'Unknown'
							END 
		  ,tat.transaction_begin_time	   
	FROM sys.dm_tran_locks lck (NOLOCK)
	  INNER JOIN sys.dm_tran_session_transactions ts (NOLOCK)
		ON lck.request_session_id = ts.session_id	
	  INNER JOIN SpidList s  --- requested spids
		ON s.Spid  = lck.request_session_id
	  LEFT OUTER JOIN sys.dm_tran_active_transactions tat (NOLOCK)
		ON ts.transaction_id = tat.transaction_id
	  LEFT OUTER JOIN sys.dm_exec_connections con (NOLOCK)
		ON ts.session_id = con.session_id
	  LEFT OUTER JOIN sys.partitions pt (NOLOCK)
		ON lck.resource_associated_entity_id = pt.[partition_id]
	  LEFT OUTER JOIN sys.objects o  (NOLOCK)
		ON pt.object_id = o.object_id
	  LEFT OUTER JOIN sys.dm_exec_requests execr (NOLOCK)
		ON con.session_id = execr.session_id
	 OUTER  APPLY (SELECT *,HashKeyFrom = 'Table'
                   FROM dbo.ShipperIdentifier (NOLOCK)--hardcoded
                   WHERE %%lockres%% = lck.resource_description
				   UNION ALL
				   SELECT *, Key_from_obj = 'Index'
                   FROM dbo.ShipperIdentifier WITH (INDEX =UC_ShippierId_IdentifierValue, NOLOCK) ----hardcoded
                   WHERE %%lockres%% = lck.resource_description
                  )  LockedResourceValues
	WHERE lck.resource_database_id= DB_ID()
		AND o.[name] = N'ShipperIdentifier'; --hardcoded
GO

