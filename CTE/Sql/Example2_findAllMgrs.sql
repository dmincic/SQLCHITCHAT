	DECLARE @EmpId INT = 10;

	;WITH cte1 AS
	(
		SELECT EmpId
			  ,MgrId
		FROM dbo.Employees
		WHERE EmpId = @EmpId --start from Emp
 
		UNION ALL
  
		SELECT e.EmpId
			  ,e.MgrId
		FROM dbo.Employees e
		INNER JOIN cte1 c
			ON e.EmpId = c.MgrId --get Mgr from cte1
	)
	SELECT EmpId
		  ,MgrId
	FROM cte1
	WHERE MgrId IS NOT NULL; -- the "big boss, EmpId=1 does not have
	                         -- superior, so exclude MgrId = NULL