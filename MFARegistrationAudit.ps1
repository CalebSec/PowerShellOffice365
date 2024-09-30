# Define the time range for the query
$startDate = "2024-08-26T00:00:00Z"
$endDate = "2024-09-06T23:59:59Z"

# Define the Graph API endpoint for directory audits
$graphEndpoint = "https://graph.microsoft.com/v1.0/auditLogs/directoryAudits"

# Filter query: Looking for "Register security info" events (MFA registration)
$filter = "?$filter=activityDisplayName eq 'Register security info' and activityDateTime ge $startDate and activityDateTime le $endDate"

# Authenticate and connect to Microsoft Graph
Connect-MgGraph -Scopes "AuditLog.Read.All", "Directory.Read.All"

# Get the audit logs from the Graph API
$response = Invoke-MgGraphRequest -Method GET -Uri "$graphEndpoint$filter"

# Prepare to export results
$exportData = @()

# Parse and store the results
$logs = $response.value
foreach ($log in $logs) {
    $userData = [PSCustomObject]@{
        DisplayName       = $log.initiatedBy.user.displayName
        UserPrincipalName = $log.initiatedBy.user.userPrincipalName
        RegistrationDate  = $log.activityDateTime
    }
    $exportData += $userData
}

# Export the data to CSV
$exportPath = "C:\Temp\MFA_RegistrationLogs.csv"
$exportData | Export-Csv -Path $exportPath -NoTypeInformation

Write-Host "Export completed. File saved to $exportPath"
# Disconnect from Microsoft Graph
Disconnect-MgGraph
