
/*
sp_execute_external_script   
    @language = N'language' ,   
    @script = N'script',  
    @input_data_1 = ] 'input_data_1'   
    [ , @input_data_1_name = ] N'input_data_1_name' ]   
    [ , @output_data_1_name = 'output_data_1_name' ]  
    [ , @parallel = 0 | 1 ]  
    [ , @params = ] N'@parameter_name data_type [ OUT | OUTPUT ] [ ,...n ]'  
    [ , @parameter1 = ] 'value1' [ OUT | OUTPUT ] [ ,...n ]  
    [ WITH <execute_option> ]  
[;] 
*/

EXEC sys.sp_execute_external_script
         @language = N'Python'
        ,@script   = N'

dfpivot_out = df.pivot_table(index = ["Shipcountry"], \
                              columns =["OrderYear"], \
                              values = ["Freight"], \
                              aggfunc={"Freight":sum}).reset_index(level="Shipcountry")

## dfpivot_out =dfpivot_out.reset_index(level="Shipcountry") ##we can reshape the data frame in a separate statement.
print(dfpivot_out)
' 
        ,@input_data_1 =N'SELECT   Orderid
                                  ,Custid
                                  ,Orderdate
                                  ,OrderYear
                                  ,Shipperid
                                  ,OrderValue = CAST(OrderValue AS FLOAT)
                                  ,Freight = CAST(Freight AS FLOAT)
                                  ,Shipname
                                  ,Shipaddress
                                  ,Shipcity
                                  ,Shipregion
                                  ,Shipcountry 
                        FROM dbo.Orders_testPivot;'
        ,@input_data_1_name =N'df' -- the default value is InputDataSet
        ,@output_data_1_name =N'dfpivot_out'
    WITH RESULT SETS  ((Shipcountry NVARCHAR(15),[2018] MONEY, [2019]  MONEY,[2020] MONEY));
