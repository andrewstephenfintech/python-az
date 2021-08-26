import os
from az.cli import az

# if "az account get-access-token --query "expiresOn" --output tsv" returns null then login

# log in

query = """
account get-access-token --query "expiresOn" 
"""
exit_code,result_dict,log = az (query)

if (1 == exit_code) :
    exit_code,result_dict,log = az ("login")
else :
    exit_code,result_dict,log = az ("account list")

i=0
for res in result_dict:
    print ("{} Name: {}".format(i,res['name']))
    i += 1


#############################################
# Get subscription
#############################################


value = input("enter subscription:")

res = result_dict[int(value)]

query = """
account set --subscription "{}"
""".format(res['id'])

print (query)
exit_code,result_dict,log = az (query)

print (exit_code, result_dict,log)

#############################################
# Resources under subscription
#############################################

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

#############################################
# Resource groups under subscription
#############################################

#az functionapp list --resource-group FTOS-Reliance-dev

query = f"""
az functionapp list --resource-group {res['resourceGroup']}
"""
print (query)
exit_code,result_dict,log = az (query)

print (result_dict)

#az webapp log tail --resource-group FTOS-Reliance-dev --name FTOS-Reliance-DEV-FileRename