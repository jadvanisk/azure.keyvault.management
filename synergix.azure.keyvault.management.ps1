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
    Some text here

#>

#region Main

# ** Task list *** 

# Login to Azure Tenant account

# Create Azure AD normal test user accounts
# Create Azure AD PAM test user accounts
# Create security groups, one dynamic and one is assigned
# Register Apps
# 1. EUD
# 2. PAM

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
