
	DECLARE @EmpId INT = 3;

	;WITH cte1 AS
	(
		SELECT EmpId
			  ,MgrId
			  ,recLvl = 0     -- anchor gives us the EmpId 's direct subordinates
		FROM dbo.Employees    -- (the first hierarchy level)
		WHERE MgrId = @EmpId 
 
		UNION ALL
  
		SELECT e.EmpId
			  ,e.MgrId
			  ,recLvl =c.recLvl + 1  --next hierarchy level
		FROM dbo.Employees e
		INNER JOIN cte1 c
			ON e.MgrId = c.EmpId 
	)
	SELECT EmpId
		  ,MgrId
		 -- ,recLvl
	FROM cte1
	WHERE recLvl <= 1; --restrict number of recursions to 1
    --WHERE recLvl = 2; -- gives us only the third level of Emp's subordinates
	