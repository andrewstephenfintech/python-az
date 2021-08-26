
import os
from az.cli import az

# if "az account get-access-token --query "expiresOn" --output tsv" returns null then login

query = """
account get-access-token --query "expiresOn" 
"""
exit_code,result_dict,log = az (query)

if (1 == exit_code) :
    exit_code,result_dict,log = az ("login")
else :
    exit_code,result_dict,log = az ("account list")

# az account list --output table
# az account get-access-token

i=0
for res in result_dict:
    print ("{} Name: {}".format(i,res['name']))
    i += 1

value = input("enter subscription:")

res = result_dict[int(value)]

query = """
account set --subscription "{}"
""".format(res['id'])

print (query)
exit_code,result_dict,log = az (query)

query = """
resource list --subscription "{}" --query "[?type=='Microsoft.Web/sites']"
""".format(res['name'])

print (query)
exit_code,result_dict,log = az (query)

i=0
for res in result_dict :    
    print ("{}: name {}, {}".format(i, res['name'], res['resourceGroup']))
    i += 1

value = input("enter target:")
res = result_dict[int(value)]

query = """
webapp config connection-string list --name {} --resource-group {} --query "[?name=='EbsSqlServer']"
""".format(res['name'], res['resourceGroup'])

# az webapp config appsettings list --name app-reliance-dev --resource-group FTOS-Reliance-dev --query "[?name=='ftosStorageService-AzureBlob-connectionString']"
# webapp config connection-string list --name {} --resource-group {}
# 
print (query)
exit_code,result_dict,log = az (query)

for res in result_dict : 
    print (res['value'])

# conn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=test;DATABASE=test;UID=user;PWD=password')
# conn = pyodbc.connect(driver='{SQL Server}',
#                       server='tcp:sql-reliance-qa.database.windows.net,1433',
#                       database='sqldb-reliance-qa', 
#                       uid='ftosadmin', 
#                       pwd='relianceBank1dhd32*RO')
# Data Source=sql-reliance-dev.database.windows.net;Initial Catalog=sqldb-reliance-dev;Integrated Security=False;User ID=ftosadmin;Password=oAp*12Ii9sd2mp13



