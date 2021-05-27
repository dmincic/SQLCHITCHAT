## Create a simple connection to Sql Server using .NET Framework Data Provider for Sql Server

$sqlConn = New-Object System.Data.SqlClient.SqlConnection;

$sqlConn.ConnectionString = @('Data Source=tcp:<server\instance_name>;' `
                             +'Initial Catalog=testCollation;' `
                             +'Integrated Security=True;' `
                             +'Pooling=False;' `
                             +'Application Name=DotNET;');

## Open and Close the connection
$sqlConn.Open();

    $sqlCmd = $sqlConn.CreateCommand()
    $sqlCmd.CommandText = "SELECT * FROM dbo.Employees WHERE LastName = @lname";

    $sqlParam = New-Object System.Data.SqlClient.SqlParameter("@lname",[System.Data.sqlDbType]::NVarChar,50);

    $sqlCmd.Parameters.ADD($sqlParam).Value="Goldberg";
    ##execute the parameterised batch request
    $sqlCmd.ExecuteScalar()

$sqlConn.Close();   
$sqlConn.Dispose();