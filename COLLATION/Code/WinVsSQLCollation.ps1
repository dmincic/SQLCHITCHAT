## Create a simple connection to Sql Server using .NET Framework Data Provider for Sql Server

using namespace System.Data.SqlClient;
using namespace System.Data;

$sqlConn = New-Object SqlConnection;

$sqlConn.ConnectionString = @('Data Source=tcp:<server\instance_name>;' `
                             +'Initial Catalog=testCollation;' `
                             +'Integrated Security=True;' `
                             +'Pooling=False;' `
                             +'Application Name=DotNET;');

## Open and Close the connection
$sqlConn.Open();

    $sqlCmd = $sqlConn.CreateCommand()
    $sqlCmd.CommandText = "SELECT * FROM dbo.Employees WHERE LastName = @lname";

    $sqlParam = New-Object SqlParameter("@lname", [sqlDbType]::NVarChar,50);

    $sqlCmd.Parameters.ADD($sqlParam).Value="Goldberg";
    ##execute the parameterised batch request
    $sqlCmd.ExecuteScalar()

$sqlConn.Close();   
$sqlConn.Dispose();