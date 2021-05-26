

import pyodbc

lname = "Goldberg"

##{SQL Server};'
##ODBC Driver 17 for SQL Server
conn = pyodbc.connect('Driver={ODBC Driver 17 for SQL Server};'  
                      'Server=tcp:ENETT-NB290\\SQL2019;'
                      'Database=testCollation;'
                      'Trusted_Connection=yes;'
		              'Poolig = false;'
                      'APP=This is me, Python' )

# You can use the Application name (APP key-value pair) to find the specific connection/session
# Run the query below before exiting the command window.
#     SELECT session_id
#            ,program_name
#            ,client_interface_name
#     FROM sys.dm_exec_sessions
#     WHERE session_id >51
#
cursor = conn.cursor()
query = "SELECT * FROM dbo.Employees WHERE LastName = ?;"
cursor.execute(query,lname)

## get the list of drivers installed on a local pc
## or run syswow64\odbcad32.exe(32bit) .. system32\odbcad32.exe (64bit)

##print (pyodbc.drivers() ) 

input("Just press Enter to exit:") ##prevent cmd window from closing