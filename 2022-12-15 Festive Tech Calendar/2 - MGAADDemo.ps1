# Source: https://github.com/johnthebrit/RandomStuff/blob/master/AzureAD/MGAADDemo.ps1

# Legacy modules leveraging the Azure AD Graph
Find-Module MSOnline
Find-Module AzureAD*

# Some modules available in Az.Resources related to Azure AD
Get-AzADUser | Format-Table UserPrincipalName, DisplayName -AutoSize
Get-AzADGroup | Format-Table DisplayName, Id -AutoSize
$JLGroup = Get-AzADGroup | Where-Object {$_.DisplayName -eq 'JusticeLeague'}
Get-AzADGroupMember -GroupObjectId $JLGroup.Id | Format-Table UserPrincipalName, DisplayName -AutoSize
Get-AzADApplication
Get-Command -Module Az.Resources -Noun AzAD* #Lots of them

#API from REST. Already signed into Az so use to get a graph token
Install-Module --Name Az
Connect-AzAccount -UseDeviceAuthentication
Get-AzVm | Format-Table Name,Location
$accessToken = (Get-AzAccessToken -ResourceUrl "https://graph.microsoft.com").Token #MS Graph audience

$accessToken | Set-Clipboard

# Inspect the token
Start-Process https://jwt.io/

$authHeader = @{
    'Content-Type'='application/json'
    'Authorization'='Bearer ' + $accessToken
}

#Submit the REST call for the list guest users!
### NOTE IN POWERSHELL I HAVE TO ESCAPE THE $ or it gets ignored!!!!
$resp = Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/users/?`$filter=userType eq 'guest'" -Method GET -Headers $authHeader
$resp = Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/users" -Method GET -Headers $authHeader

$resp.value

#But we don't want to do this. Lets use the Microsoft Graph SDK PowerShell module!

#Install for all users
#https://github.com/microsoftgraph/msgraph-sdk-powershell
Find-Module microsoft.graph
Install-Module microsoft.graph -Scope AllUsers -Force

#Check installed version
Get-InstalledModule -Name Microsoft.Graph -AllVersions

#Connect
Connect-MgGraph -UseDeviceAuthentication
#This will use a default scope of permissions
#Each API in graph has a certain permission scope required

Get-MgUser | Format-Table UserPrincipalName, displayname, jobtitle -AutoSize

#https://docs.microsoft.com/en-us/graph/permissions-reference
Connect-MgGraph -Scopes "User.Read.All","Group.ReadWrite.All","UserAuthenticationMethod.Read.All" -UseDeviceAuthentication #specifying specific scopes of permissions (will need to have these as the user)
#For apps can connect with a client ID and certificate (not a secret) using -ClientID, TenantID and CertificateName

#Switch to beta profile to light up features
Select-MgProfile -Name "beta"

#View my scope
Get-MgContext
(Get-MgContext).Scopes

#Environments, i.e. various clouds
Get-MgEnvironment

#Good examples at https://github.com/microsoftgraph/msgraph-sdk-powershell/tree/dev/samples

Start-Process https://github.com/microsoftgraph/msgraph-sdk-powershell/tree/dev/samples

git clone https://github.com/microsoftgraph/msgraph-sdk-powershell.git

#Get tenant info
Get-MgOrganization | Select-Object DisplayName, City, State, VerifiedDomains
Get-MgOrganization | Select-Object -expand AssignedPlans

#View users
Get-MgUser | Format-Table UserPrincipalName, displayname, jobtitle -AutoSize
#View guest users . USE THE SAME FILTERS as the API
Get-MgUser -Filter "userType eq 'guest'"
#Use the filter to look for inactive users
Connect-MgGraph -Scopes "AuditLog.Read.All" #required for next command
Get-MgUser -Filter "signInActivity/lastSignInDateTime le 2021-01-01T00:00:00Z"

#Look at custom attributes
Connect-MgGraph -Scopes "User.Read.All","CustomSecAttributeAssignment.ReadWrite.All"
Get-MgDirectoryAttributeSet
$user = Get-MgUser -UserId jan.egil.ring@contoso.com
$user | Format-List
$user.CustomSecurityAttributes

$accessToken = (Get-AzAccessToken -ResourceUrl "https://graph.microsoft.com").Token #MS Graph audience
$authHeader = @{
    'Content-Type'='application/json'
    'Authorization'='Bearer ' + $accessToken
}
$resp = Invoke-RestMethod -Uri "https://graph.microsoft.com/beta/users/$($user.Id)" -Method GET -Headers $authHeader
$resp


#Could then chain together
Get-MgUser -Filter "signInActivity/lastSignInDateTime le 2021-05-01T00:00:00Z" |
     ForEach-Object {Get-MgUserMemberOf -UserId $_.Id }

$DisableUserHash = @{'accountEnabled' = 'false'}
Get-MgUser -Filter "signInActivity/lastSignInDateTime le 2021-05-01T00:00:00Z" |
    ForEach-Object {@{ UserId=$_.Id}} | Update-MgUser -Settings $DisableUserHash -WhatIf
#View service principals
Get-MgServicePrincipal | Select-Object id, AppDisplayName | Where-Object { $_.AppDisplayName -like "*sav*" }

#View groups
Get-MgGroup -top 20 | Select-Object id, DisplayName, GroupTypes

#View group members
$group = Get-MgGroup | Where-Object {$_.DisplayName -eq "Workplace Users"}
#or
$group = Get-MgGroup -Filter "displayName eq 'Workplace Users'"

#The foreach just gets the UserId populated with the Id returned from previous command then continues down pipeline
Get-MgGroupMember -GroupId $group.Id | ForEach-Object { @{ UserId=$_.Id}} | Get-MgUser | Select-Object id, DisplayName, Mail
Get-MgGroupOwner -GroupId $group.Id | ForEach-Object { @{ UserId=$_.Id}} | Get-MgUser | Select-Object id, DisplayName, Mail

#View authentication methods for a user
Get-MgUserAuthenticationMethod -UserId jan.egil.ring@contoso.com
#Authenticator types for a user
#Microsoft Authenticator
Get-MgUserAuthenticationMicrosoftAuthenticatorMethod -UserId jan.egil.ring@contoso.com
#Email
Get-MgUserAuthenticationEmailMethod -UserId jan.egil.ring@contoso.com


#Look for commands
Get-Command -Module microsoft.graph.* -Noun *licen* -verb get | Format-Table Name, Source -AutoSize

#Look at licenses
Get-MgUserLicenseDetail -UserId jan.egil.ring@contoso.com | Format-Table SkuPartNumber, SkuId -AutoSize


#Remember can do more than just AAD


#https://docs.microsoft.com/en-us/graph/api/user-sendmail?view=graph-rest-1.0&tabs=http
Disconnect-MgGraph
Connect-MgGraph -Scopes "Mail.Send"  #specifying specific scopes of permissions (will need to have these as the user)
Connect-MgGraph -Scopes "Calendars.ReadWrite"  #To see consent prompt

Find-MgGraphPermission -SearchString mail
(Find-MgGraphCommand -Command Send-MgUserMail -ApiVersion v1.0).Permissions

Install-Module PSQuotes
$Message = Get-DadJoke
$Message

$Message = @{
    "subject" = "Dad joke of the day"
    "body" = @{
      "content" = $Message
    }
    "toRecipients" = @(
        @{
           "emailAddress" = @{
              "address" = "jan.egil.ring@contoso.com"
           }
         }
     )
 }


Send-MgUserMail -userId jan.egil.ring@contoso.com -Message $Message