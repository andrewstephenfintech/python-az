Set-AzContext -Subscription "S-P-MT-Reliance"
Connect-AzAccount


#Get-AzResource | ft
#
#Get-AzResource -ResourceGroupName FTOS-Reliance-dev | ft
#
#Get-AzResource -ResourceGroupName FTOS-Reliance-dev -ResourceType Microsoft.Web/sites 
#
#
#Get-AzTag -ResourceId /subscriptions/f7698ea8-16ba-4211-862c-663cca58d856/resourceGroups/FTOS-Reliance-dev/providers/Microsoft.Web/sites/app-reliance-dev

$xml = [xml](Get-AzWebAppPublishingProfile -ResourceGroupName "FTOS-Reliance-dev" -Name "app-reliance-dev")

$ConnectionString = $xml.SelectNodes("//publishData//publishProfile[@publishMethod=`"MSDeploy`"]/databases/add[@name=`"EbsSqlServer`"]/@connectionString").value

$sql = @'
SELECT  QD.Name as Name, 
        ERT.Name as ExchangeType,
        FC.code as FromCurrency,
        TC.Code as ToCurrency,
        QD.QuandlCode as QuandlCode
FROM    ebs.FTOS_IB_QuandlData QD
JOIN    ebs.FTOS_CMB_ExchangeRateType ERT on (QD.ExchangeTypeId = ERT.FTOS_CMB_ExchangeRateTypeid)
JOIN    ebs.FTOS_CMB_Currency FC on (QD.FromCurrencyId = FC.FTOS_CMB_Currencyid)
JOIN    ebs.FTOS_CMB_Currency TC on (QD.ToCurrencyId = TC.FTOS_CMB_Currencyid)
'@
 
Invoke-Sqlcmd -ConnectionString $ConnectionString -Query $sql  -IncludeSqlUserErrors -Verbose -OutputSqlErrors:$true

# az webapp config appsettings list --name app-reliance-dev --resource-group FTOS-Reliance-dev --subscription MySubscription

$webAppSettings = (Get-AzwebApp -ResourceGroupName FTOS-Reliance-dev -Name app-reliance-dev).SiteConfig.ConnectionStrings 

$connect = $webAppSettings | Select-Object -Property Name, Type, ConnectionString

$dbdetails = $connect.ConnectionString -replace (' ','') 

$dbdetails = $dbdetails | ConvertFrom-String -delimiter ';'

$sqlserver = $dbdetails.p1.split('=')[1]

$dbname = $dbdetails.p2.split('=')[1]

$sqlusername = $dbdetails.p4.split('=')[1]

$sqlpassword = $dbdetails.p5.split('=')[1]




$xml.publishData.publishProfile.databases

# -Format "Ftp" -OutputFile "C:\Users\contoso\outputfile.publishsettings"

<publishData>
  <publishProfile profileName="app-reliance-dev - Web Deploy" publishMethod="MSDeploy" publishUrl="app-reliance-dev.scm.azurewebsites.net:443" msdeploySite="app-reliance-dev" userName="$app-reliance-dev" userPWD="2650iaBfFb8WNREmmPJgc4bfvHdAFHptlcG0kTZal2d5pY5HBWCatiAjgcQZ" destinationAppU
rl="https://app-reliance-dev.azurewebsites.net" SQLServerDBConnectionString="Data Source=sql-reliance-dev.database.windows.net;Initial Catalog=sqldb-reliance-dev;Integrated Security=False;User ID=ftosadmin;Password=oAp*12Ii9sd2mp13" mySQLDBConnectionString="" hostingProviderForumLink="" co
ntrolPanelLink="http://windows.azure.com" webSystem="WebSites" targetDatabaseEngineType="sqlazuredatabase" targetServerVersion="Version100">
    <databases>
      <add name="EbsSqlServer" connectionString="Data Source=sql-reliance-dev.database.windows.net;Initial Catalog=sqldb-reliance-dev;Integrated Security=False;User ID=ftosadmin;Password=oAp*12Ii9sd2mp13" providerName="System.Data.SqlClient" type="Sql" targetDatabaseEngineType="sqlazuredat
abase" targetServerVersion="Version100" />
    </databases>
  </publishProfile>
  <publishProfile profileName="app-reliance-dev - FTP" publishMethod="FTP" publishUrl="ftp://waws-prod-am2-407.ftp.azurewebsites.windows.net/site/wwwroot" ftpPassiveMode="True" userName="app-reliance-dev\$app-reliance-dev" userPWD="2650iaBfFb8WNREmmPJgc4bfvHdAFHptlcG0kTZal2d5pY5HBWCatiAjgc
QZ" destinationAppUrl="https://app-reliance-dev.azurewebsites.net" SQLServerDBConnectionString="Data Source=sql-reliance-dev.database.windows.net;Initial Catalog=sqldb-reliance-dev;Integrated Security=False;User ID=ftosadmin;Password=oAp*12Ii9sd2mp13" mySQLDBConnectionString="" hostingProv
iderForumLink="" controlPanelLink="http://windows.azure.com" webSystem="WebSites" targetDatabaseEngineType="sqlazuredatabase" targetServerVersion="Version100">
    <databases>
      <add name="EbsSqlServer" connectionString="Data Source=sql-reliance-dev.database.windows.net;Initial Catalog=sqldb-reliance-dev;Integrated Security=False;User ID=ftosadmin;Password=oAp*12Ii9sd2mp13" providerName="System.Data.SqlClient" type="Sql" targetDatabaseEngineType="sqlazuredat
abase" targetServerVersion="Version100" />
    </databases>
  </publishProfile>
  <publishProfile profileName="app-reliance-dev - Zip Deploy" publishMethod="ZipDeploy" publishUrl="app-reliance-dev.scm.azurewebsites.net:443" userName="$app-reliance-dev" userPWD="2650iaBfFb8WNREmmPJgc4bfvHdAFHptlcG0kTZal2d5pY5HBWCatiAjgcQZ" destinationAppUrl="https://app-reliance-dev.az
urewebsites.net" SQLServerDBConnectionString="Data Source=sql-reliance-dev.database.windows.net;Initial Catalog=sqldb-reliance-dev;Integrated Security=False;User ID=ftosadmin;Password=oAp*12Ii9sd2mp13" mySQLDBConnectionString="" hostingProviderForumLink="" controlPanelLink="http://windows.
azure.com" webSystem="WebSites" targetDatabaseEngineType="sqlazuredatabase" targetServerVersion="Version100">
    <databases>
      <add name="EbsSqlServer" connectionString="Data Source=sql-reliance-dev.database.windows.net;Initial Catalog=sqldb-reliance-dev;Integrated Security=False;User ID=ftosadmin;Password=oAp*12Ii9sd2mp13" providerName="System.Data.SqlClient" type="Sql" targetDatabaseEngineType="sqlazuredat
abase" targetServerVersion="Version100" />
    </databases>
  </publishProfile>
</publishData>


# dir env:

# https://app-reliance-dev.scm.azurewebsites.net/Env
# https://app-reliance-dev.azurewebsites.net/admin/functions/Environment%20svariables/keys
# get /admin/functions/{functionname}/keys

# {"deployment_branch":"master","SCM_TRACE_LEVEL":"1","SCM_COMMAND_IDLE_TIMEOUT":"60","SCM_LOGSTREAM_TIMEOUT":"7200","SCM_BUILD_ARGS":"","aspnet:PortableCompilationOutput":"true","aspnet:PortableCompilationOutputSnapshotType":"Microsoft.Web.Compilation.Snapshots.SnapshotHelper, Microsoft.Web.Compilation.Snapshots, Version=1.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35","aspnet:DisableFcnDaclRead":"true","SCM_GIT_USERNAME":"windowsazure","SCM_GIT_EMAIL":"windowsazure","webpages:Version":"3.0.0.0","webpages:Enabled":"true","webactivator:assembliesToScan":"Kudu.Services.Web","ftosStorageService-AzureBlob-rootContainer":"uploadebs","ScmType":"None","WEBSITE_SITE_NAME":"app-reliance-dev","ftosStorageService-AzureBlob-connectionString":"DefaultEndpointsProtocol=https;EndpointSuffix=core.windows.net;AccountName=storagereliancedev;AccountKey=doMs1xKJJKzMw3+6RyUFDB/4rK82Ifp3y5QsiKAx6b7J53jlR5DYPZsakEcof3zFnoxFD3mH8U6+4LaokCGwhg==","WEBSITE_AUTH_ENABLED":"False","REMOTEDEBUGGINGVERSION":"16.0.30709.132","AzureWebJobsStorage":"DefaultEndpointsProtocol=https;EndpointSuffix=core.windows.net;AccountName=storagereliancedev;AccountKey=doMs1xKJJKzMw3+6RyUFDB/4rK82Ifp3y5QsiKAx6b7J53jlR5DYPZsakEcof3zFnoxFD3mH8U6+4LaokCGwhg==","ApplicationInsightsAgent_EXTENSION_VERSION":"~2","APPLICATIONINSIGHTS_CONNECTION_STRING":"InstrumentationKey=eb919c96-f703-4a79-9943-4aa9114b19d3;IngestionEndpoint=https://westeurope-5.in.applicationinsights.azure.com/","feature-logging-azure-appinsights":"enabled=1; logLevel=Verbose; flushInterval=1m; apiKey=eb919c96-f703-4a79-9943-4aa9114b19d3","AzureWebJobsDashboard":"DefaultEndpointsProtocol=https;EndpointSuffix=core.windows.net;AccountName=storagereliancedev;AccountKey=doMs1xKJJKzMw3+6RyUFDB/4rK82Ifp3y5QsiKAx6b7J53jlR5DYPZsakEcof3zFnoxFD3mH8U6+4LaokCGwhg==","XDT_MicrosoftApplicationInsights_Mode":"default","APPINSIGHTS_INSTRUMENTATIONKEY":"eb919c96-f703-4a79-9943-4aa9114b19d3"}