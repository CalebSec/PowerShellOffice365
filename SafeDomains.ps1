# Connect to Exchange Online
Connect-ExchangeOnline 

# Define CSV file path
$csvFile = "<file path to the CSV>"

# Import the CSV file
$domains = Import-Csv -Path $csvFile

# Initialize a list for safe domains
$safeDomains = @()

# Loop through each domain and add to the safe domains list
foreach ($domain in $domains) {
    $safeDomains += $domain.domain
}

# Update the policy to include safe sender domains
try {
    # Replace 'YourPolicyName' with the name of your inbound spam policy
    Set-HostedContentFilterPolicy -Identity "<Name of the policy to add the allowed domains>" -AllowedSenderDomains $safeDomains
    Write-Host "Successfully updated safe sender domains for policy 'YourPolicyName'"
} catch {
    Write-Host "Error while updating policy: $_"
} finally {
    # Disconnect the Exchange Online session
    Disconnect-ExchangeOnline
}

# Install the Exchange Online Management module if it's not installed
Install-Module -Name ExchangeOnlineManagement -Force -AllowClobber

# Update the module if it's already installed
Update-Module -Name ExchangeOnlineManagement