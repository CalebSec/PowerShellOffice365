#The prerequisite for this script is to installl the Azure connect module
#Install-Module AzureAD

#Connect To AzureConnect
#You will need an account with the correct permissions for Microsoft Graph
Connect-AzureAD


# Get all users
$AllUsers = Get-AzureADUser -All $true

# Initialize an array to hold users without MFA
$UsersWithoutMFA = @()

# Loop through each user and check their MFA status
foreach ($User in $AllUsers) {
    $MFAStatus = Get-MsolUser -UserPrincipalName $User.UserPrincipalName | Select-Object -ExpandProperty StrongAuthenticationMethods
    if ($MFAStatus.Count -eq 0) {
        $UsersWithoutMFA += $User
    }
}

# Export the list to a CSV file
#Replace the path with the desired write location for the exported information
$UsersWithoutMFA | Select-Object DisplayName, UserPrincipalName | Export-Csv -Path "<Path:path write the file to>" -NoTypeInformation
