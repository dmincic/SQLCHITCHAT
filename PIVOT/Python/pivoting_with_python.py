import pyodbc
import pandas as pd
import numpy as np

class Sql:
    def __init__(self, database, server="tcp:<server_name>\\<Instance_Name>"): ##server_name\\Instance_name

        # here we are telling python what to connect to (our SQL Server)
        self.cnxn = pyodbc.connect("Driver={SQL Server};" ## Native Client 11.0
                                   "Server="+server+";"
                                   "Database="+database+";"
                                   "Trusted_Connection=yes;")

##instantiate object
Sql1 = Sql('<database_name>')

##DON'T NEED TO use table expression, no need to cast not supported data types
## I guess the casting is done by pyodbc driver
query1 = "SELECT * FROM dbo.Orders_testPivot"

df = pd.read_sql(query1,Sql1.cnxn) ##read data into DataFrame

dfpivot_out = df.pivot_table(index = ["Shipcountry"], \
                              columns =["OrderYear"], \
                              values = ["Freight"], \
                              aggfunc={"Freight":sum}, \
                              fill_value="NULL").reset_index(level="Shipcountry")

print(dfpivot_out)

