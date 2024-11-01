#Connect to Exchange Online
#Connect-ExchangeOnline

$users = @("user1@yourdomain.com", "user2@yourdomain.com", "user3@yourdomain.com")

foreach ($user in $users) {
    #Disable SMTP
    Set-CasMailbox -Identity $user -SmtpClientAuthenticationDisabled $true
    # Disable POP3
    Get-Mailbox -ResultSize Unlimited | Set-CasMailbox -PopEnabled $false

    # Disable IMAP
    Get-Mailbox -ResultSize Unlimited | Set-CasMailbox -ImapEnabled $false
}

#Audit the changes
#Must specify the CSV Path
Get-Mailbox -ResultSize Unlimited | Select-Object DisplayName,PopEnabled,ImapEnabled,SmtpClientAuthenticationDisabled | Export-Csv -Path <"C:\path\to\your\file.csv"> -NoTypeInformation
