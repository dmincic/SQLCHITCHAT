
import uuid,pyodbc

# Create connection
cnxn = pyodbc.connect(driver=r"{SQL Server}" \
                     ,server=r".\SQL2019" \
                     ,database=r"TEST2019DB" \
                     ,Trusted_Connection=r"yes" \
                     ,autocommit=True) ## default is False -> set implicit_transactions on

cursor = cnxn.cursor()

#create a guid value
ui = uuid.uuid4()

#define tsql command and params
sql = "EXECUTE dbo.TestGUIDinsert @guid = ?"
params = ui

#execute stored proc 
cursor.execute(sql,params) ##RPC call - parameterised batch request

print(ui)
cnxn.close()

