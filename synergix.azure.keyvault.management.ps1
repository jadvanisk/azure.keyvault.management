<#
.SYNOPSIS
    Some text here
    
.OUTPUTS
    Some text here

.EXAMPLE
    Some text here
    Some text here

Description
-----------
  Some text here

.EXAMPLE
    Some text here
    Some text here

Description
-----------
    Some text here

.LINK
    https://dscottraynsford.wordpress.com/2017/04/17/using-azure-key-vault-with-powershell-part-1/

#>

#region Main

# ** Task list *** 

# Check if required modules are installed
# https://www.powershellgallery.com/packages/AzureAD/2.0.2.4

# Import required modules for Azure
# Install-Module -Name AzureAD

# Import required modules for Azure Resource Manager
# We should be using AzureRM and not Azure module mentioned above.
# Install-Module -Name AzureRM

# The name of the Azure subscription to install the Key Vault into
# This should command from command line parameter
$tenantID = 'ab968efd-ce09-4c23-b54e-1bf93f777bb7'

Connect-AzureAD -TenantId $tenantID


# The name of the Azure subscription to install the Key Vault into
# This should command from command line parameter
$subscriptionName = 'MySubscription'

# The resource group that will contain the Key Vault to create to contain the Key Vault
# This should command from command line parameter
$resourceGroupName = 'MyKeyVaultRG'

# The name of the Key Vault to install
# This should command from command line parameter
$keyVaultName = 'MyKeyVault'

# The Azure data center to install the Key Vault to
# This should command from command line parameter
$location = 'southcentralus'

# These are the Azure AD users that will have admin permissions to the Key Vault
# This should command from command line parameter
$keyVaultAdminUsers = @('John Smith','Jane Smith')

# Create a new secret, use new-guid to generate a name for the secret or use a simple name ex. mySecret007
# Assign additional parameters as approprite
  
  Set-AzureKeyVaultSecret -VaultName $keyVaultName -Name '6d860a24-ccfe-4a6d-a574-87efcad53183' `
  -SecretValue (ConvertTo-SecureString -String 'DMzw#JumbolrKcneUDumbo?~72F:fElephantSvoZ8rr$\0&eO' -AsPlainText -Force) `
  -ContentType 'txt' `
  -NotBefore ((Get-Date).ToUniversalTime()) `
  -Expires ((Get-Date).AddYears(2).ToUniversalTime()) `
  -Disable:$false `
  -Tags @{ 'Risk' = 'High'; }

# Login to Azure Tenant account


# Select the appropriate subscription
# Select-AzureRmSubscription -SubscriptionName $subscriptionName


# Create Azure AD normal test user accounts
# Login-AzureRMAccount

# Make the Key Vault provider is available
Register-AzureRmResourceProvider -ProviderNamespace Microsoft.KeyVault

# Create the Resource Group
New-AzureRmResourceGroup -Name $resourceGroupName -Location $location

# Create the Key Vault (enabling it for Disk Encryption, Deployment and Template Deployment)
New-AzureRmKeyVault -VaultName $keyVaultName -ResourceGroupName $resourceGroupName -Location $location `
    -EnabledForDiskEncryption -EnabledForDeployment -EnabledForTemplateDeployment

# Add the Administrator policies to the Key Vault
# We must deploy only required permissions ; this is too wide open
foreach ($keyVaultAdminUser in $keyVaultAdminUsers) {
    $UserObjectId = (Get-AzureRmADUser -SearchString $keyVaultAdminUser).Id
    Set-AzureRmKeyVaultAccessPolicy -VaultName $keyVaultName -ResourceGroupName $resourceGroupName -ObjectId $UserObjectId `
        -PermissionsToKeys all -PermissionsToSecrets all -PermissionsToCertificates all
}

# Create an access policy to allow a service principal or application to get and list cryptographic keys if you know the 
# Application Id (a GUID):
Set-AzureRmKeyVaultAccessPolicy -VaultName $keyVaultName -ResourceGroupName $resourceGroupName `
  -ServicePrincipalName 'e9b1bc3c-4769-4a98-9014-b315fd2adf53' `
  -PermissionsToCertificates list,get `
  -PermissionsToKeys list,get `
  -PermissionsToSecrets list,get

# Remove unwanted access policies
Remove-AzureRmKeyVaultAccessPolicy -VaultName $keyVaultName -ResourceGroupName $resourceGroupName `
  -UserPrincipalName 'Joe.Boggs@contoso.com'

# New-AzureADUser 
# https://docs.microsoft.com/en-us/powershell/module/azuread/new-azureaduser?view=azureadps-2.0

# $PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
# $PasswordProfile.Password = "<some randomly generated 16 character complex password string>"

# $PasswordProfile.Password = New-Guid
New-AzureADUser -PasswordProfile $PasswordProfile -AccountEnabled $True -City "New York City" -Country "US" -CreationType $null -Department "End User Computing" -DisplayName "John Smith" -GivenName "John" -surname "Smith" -JobTitle "L1 Admin - End User Computing" -MailNickName "john@littleeinstein.me" -Mobile "+1 201 202 2030" -PhysicalDeliveryOfficeName "1200 Route 22 East" -PostalCode "08807" -State "NJ" -StreetAddress "1200 Route 22 East" -TelephoneNumber "+1 201 202 2030" -UsageLocation "US" -UserPrincipalName "john.smith@littleeinstein.me" -usertype "Member"

# $PasswordProfile.Password = New-Guid
New-AzureADUser -PasswordProfile $PasswordProfile -AccountEnabled $True -City "New York City" -Country "IN" -CreationType $null -Department "End User Computing" -DisplayName "Jane Smith" -GivenName "John" -surname "Smith" -JobTitle "L1 Admin - End User Computing" -MailNickName "jane@littleeinstein.me" -Mobile "+1 201 202 2030" -PhysicalDeliveryOfficeName "1200 Route 22 East" -PostalCode "08807" -State "NJ" -StreetAddress "1200 Route 22 East" -TelephoneNumber "+1 201 202 2030" -UsageLocation "IN" -UserPrincipalName "jane.smith@littleeinstein.me" -usertype "Member"

# Create Azure AD PAM test user accounts
# New-AzureADUser -PasswordProfile $PasswordProfile -AccountEnabled $True -City "New York City" -Country "US" -CreationType $null -Department "End User Computing" -DisplayName "John Smith" -GivenName "John" -surname "Smith" -JobTitle "L1 Admin - End User Computing" -MailNickName "john@littleeinstein.me" -Mobile "+1 201 202 2030" -PhysicalDeliveryOfficeName "1200 Route 22 East" -PostalCode "08807" -State "NJ" -StreetAddress "1200 Route 22 East" -TelephoneNumber "+1 201 202 2030" -UsageLocation "US" -UserPrincipalName "john.smith@littleeinstein.me" -usertype "Member"
# New-AzureADUser -PasswordProfile $PasswordProfile -AccountEnabled $True -City "New York City" -Country "US" -CreationType $null -Department "End User Computing" -DisplayName "John Smith" -GivenName "John" -surname "Smith" -JobTitle "L1 Admin - End User Computing" -MailNickName "john@littleeinstein.me" -Mobile "+1 201 202 2030" -PhysicalDeliveryOfficeName "1200 Route 22 East" -PostalCode "08807" -State "NJ" -StreetAddress "1200 Route 22 East" -TelephoneNumber "+1 201 202 2030" -UsageLocation "US" -UserPrincipalName "john.smith@littleeinstein.me" -usertype "Member"

# Create security groups, one dynamic and one is assigned, if they don't exists
New-AzureADGroup -Description "SYNERGIX Managed Azure AD Dynamic Users" -DisplayName "SYNERGIX-ADCE-2018-R2-Rev-1-EUD-Users" -SecurityEnabled $true -MailEnabled $false -MailNickName "<Not Set>"
New-AzureADGroup -Description "SYNERGIX Managed Azure AD Assigned PAM Users" -DisplayName "SYNERGIX-ADCE-2018-R2-Rev-1-EUD-PAM" -SecurityEnabled $true -MailEnabled $false -MailNickName "<Not Set>"

# Manage group membership, update member if needed
# Note, we only need to manage the PAM group since it has assigned members
# If count is 0, add members
# If count is not zero, report current group members
# If our users are not group members, add them
# Do not remove our members
# Get-AzureADGroupMember
# Add-AzureADGroupMember

# Register Apps
# 1. EUD
# 2. PAM

# Select-AzureRmSubscription -SubscriptionName "<yourSubscriptionName>"
$myApplication = New-AzureRmADApplication -DisplayName "automation-app" -HomePage "https://test.com" -IdentifierUris "https://test.com" -Password "#1234a$%pwd07"
New-AzureRmADServicePrincipal -ApplicationId $myApplication.ApplicationId
New-AzureRmRoleAssignment -RoleDefinitionName Contributor -ServicePrincipalName $myApplication.ApplicationId


# Create Service Principal with a certificate from a Certificate Authority
# https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-authenticate-service-principal-powershell
# Can there be a servicePrincipal for each Azure AD joined device and granted fine-grained role ?

# Create custom roles

# Assign Custom and Fine-Grained Roles, must be less than Contributor
# https://cmatskas.com/service-principals-in-microsoft-azure/

# Create Key Vault
# Create Key
# Read public key
# https://rahulpnath.com/blog/getting-started-with-azure-key-vault/

# Create Secret
# Encrypt Secret, using Public Key

# Build PAWEXT01 machine; accessible over Internet
# Build PAWINT01 machine; accessible in Azure only

# Create Firewall

# Read Secret
# Decrypt Secret
# https://rahulpnath.com/blog/getting-started-with-azure-key-vault/
# Example var decryptedData = await keyClient.DecryptDataAsync(keyIdentifier, "RSA_OAEP", encryptedText);

# Log entry


#endregion
