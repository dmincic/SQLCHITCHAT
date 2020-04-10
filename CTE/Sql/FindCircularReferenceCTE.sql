

DECLARE @EmpId INT = 3;

	;WITH cte1 AS
	(
		SELECT EmpId
			  ,MgrId
			  ,recLvl = 0 
              ,pth = CAST (  ISNULL(CAST(MgrId AS VARCHAR(10)),'') + '->' + CAST(EmpId AS VARCHAR(10))  AS VARCHAR(8000))
              ,isCircRef = 0 -- no circular reference
		FROM dbo.Employees
		WHERE MgrId = 3
 
		UNION ALL
  
		SELECT e.EmpId
			  ,e.MgrId
			  ,recLvl = c.recLvl  + 1
              ,c.pth + ' -> ' + CAST(e.EmpId AS VARCHAR(10))
              ,isCircRef = CASE --check if there is any EmpId who is already included in the result
								WHEN c.pth  LIKE '%' + CAST(e.EmpId AS VARCHAR(10)) + '%'  THEN 1
								ELSE 0
						   END   
		FROM dbo.Employees e
			INNER JOIN cte1 c
				ON e.MgrId = c.EmpId
	)
	SELECT cte1.EmpId
		  ,cte1.MgrId
		  ,recLvl
          ,pth
          ,isCircRef
	FROM cte1
	WHERE cte1.isCircRef = 1 --returns only circular ref. hierarchies
		AND cte1.recLvl <= 2; --limits final resut to two recursions