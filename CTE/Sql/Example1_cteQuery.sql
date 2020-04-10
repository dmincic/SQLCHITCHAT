   
DECLARE @EmpId INT = 3;

    ;WITH cte1 AS
    (
        SELECT EmpId
              ,MgrId
        FROM dbo.Employees
        WHERE MgrId = @EmpId
 
        UNION ALL
  
        SELECT e.EmpId
              ,e.MgrId
        FROM dbo.Employees e
          INNER JOIN cte1 c
            ON e.MgrId = c.EmpId
    )
    SELECT cte1.EmpId
          ,cte1.MgrId
    FROM cte1;