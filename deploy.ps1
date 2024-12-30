#create FA
#add system assigned identity
#assign Entra roles to the identity
#assign Azure permissions to the identity

#Connect-MgGraph
$graphToken = (Get-AzAccessToken -ResourceTypeName MSGraph).Token 
$secureGraphToken = (ConvertTo-SecureString -AsPlainText $graphToken)
Connect-MgGraph -Environment USGov -AccessToken $secureGraphToken
$functionAppServicePrincipal = Get-MgServicePrincipal | Where-Object { $_.ServicePrincipalType -eq 'ManagedIdentity' } | Out-GridView -PassThru -Title 'Select the Service Principal for the Function App'
#$sp = Get-MgServicePrincipal -ServicePrincipalId 1fc7fa6b-ffa7-48a0-9bf9-3e6b8398fc45
#add write permissions at the backup container scope
#add read permissions at the restore container scope

# Get MS Graph App role assignments using objectId of the Service Principal
#$assignments = Get-MgServicePrincipalAppRoleAssignedTo -ServicePrincipalId $sp.Id -All
#New-AzRoleAssignment -ObjectId $sp.Id -RoleDefinitionName "Storage Blob Data Contributor" -Scope "/subscriptions/4ba9e694-9cdb-4561-8474-0be974895a3e/resourceGroups/EntraBackup_group/providers/Microsoft.Storage/storageAccounts/entrabackupgroupa7b8"

$serviceApplicationName = "Microsoft Graph"
$serviceServicePrincipal = Get-MgServicePrincipal -Filter "displayName eq '$serviceApplicationName'"
$appRoleNames = @('Directory.Read.All', 'User.EnableDisableAccount.All')
ForEach ($appRoleName in $appRoleNames) {
    #$appRole = Get-MgServicePrincipalAppRole -ServicePrincipalId $serviceServicePrincipal.Id -AppRoleName $appRoleName
    $appRole = $serviceServicePrincipal.AppRoles | Where-Object { $_.Value -eq $appRoleName }
    New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $functionAppServicePrincipal.Id -PrincipalId $functionAppServicePrincipal.Id -AppRoleId $appRole.Id -ResourceId $serviceServicePrincipal.Id
}
