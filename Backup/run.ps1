param($Timer)

#region Initialize Variables
$now = ([System.DateTime]::UtcNow) #.ToString("yyyy-MM-ddTHHmmss")
$timestamp = $now.tostring('yyyy-MM-ddTHHmmss')
$ConnectionStringUri = $env:ResourceConfigOutputURL
Write-Host "ConnectionString URI = $ConnectionStringURI"
$chunkSize = 200
$Path = "y=$($now.ToString('yyyy'))/m=$($now.ToString('MM'))/d=$($now.ToString('dd'))/h=$($now.ToString('HH'))/m=$($now.ToString('mm'))"
Write-Host "Path = $path"
$storageToken = Connect-AcquireToken -TokenResourceUrl $storageTokenUrl
$token = Connect-AcquireToken -TokenResourceUrl $resourceManagerUrl


#Backup users
$allUsers = Get-EntraUsersREST
Upload-ToBlob -ConnectionStringURI $ConnectionStringURI -Path $Path -filename 'users' -dataToUpload $allUsers -extension 'json' -StorageToken $storageToken
#user
#group membership
#Entra roles
#Backup Groups
$allGroups = Get-EntraGroupsREST
Upload-ToBlob -ConnectionStringURI $ConnectionStringURI -Path $Path -filename 'groups' -dataToUpload $allGroups -extension 'json' -StorageToken $storageToken
#group
#group membership
#Entra roles


Write-Host ("Azure Resource Configurations are exported to " + $ConnectionStringURI)