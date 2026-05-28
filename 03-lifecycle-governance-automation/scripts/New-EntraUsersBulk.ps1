param (
    [Parameter(Mandatory = $true)]
    [string]$TenantId,
    [Parameter(Mandatory = $true)]
    [string]$ClientId,
    [Parameter(Mandatory = $true)]
    [string]$ClientSecret,
    [Parameter(Mandatory = $true)]
    [string]$CsvPath,
    [Parameter(Mandatory = $true)]
    [string]$DomainName
)

# Konwersja String do SecureString wymagana przez modul Graph
$SecretSecure = ConvertTo-SecureString $ClientSecret -AsPlainText -Force
$Credential = [System.Management.Automation.PSCredential]::new($ClientId, $SecretSecure)

Write-Host "Laczenie z Microsoft Graph API..." -ForegroundColor Cyan
Connect-MgGraph -TenantId $TenantId -Credential $Credential -NoWelcome

# Import danych z pliku CSV
$Users = Import-Csv -Path $CsvPath

foreach ($User in $Users) {
    $TargetUPN = "$($User.FirstName.Substring(0,1).ToLower()).$($User.LastName.ToLower())@$DomainName"
    $MailNickname = "$($User.FirstName.Substring(0,1).ToLower()).$($User.LastName.ToLower())"
    
    # Generowanie losowego hasla tymczasowego
    $PasswordCharList = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#"
    $TemporaryPassword = (-join ((1..14) | ForEach-Object { $PasswordCharList[(Get-Random -Maximum $PasswordCharList.Length)] }))

    $UserParams = @{
        AccountEnabled = $true
        DisplayName = "$($User.FirstName) $($User.LastName)"
        GivenName = $User.FirstName
        Surname = $User.LastName
        UserPrincipalName = $TargetUPN
        MailNickname = $MailNickname
        Department = $User.Department
        JobTitle = $User.JobTitle
        PasswordProfile = @{
            ForceChangePasswordNextSignIn = $true
            Password = $TemporaryPassword
        }
    }

    Write-Host "Tworzenie uzytkownika: $TargetUPN..." -ForegroundColor Yellow

    try {
        $NewUser = New-MgUser @UserParams
        Write-Host "Sukces! Utworzono ID: $($NewUser.Id)" -ForegroundColor Green
        Write-Host "Haslo tymczasowe dla $($User.FirstName): $TemporaryPassword" -ForegroundColor Gray
    }
    catch {
        Write-Host "Blad podczas tworzenia uzytkownika $TargetUPN" -ForegroundColor Red
    }
}

Disconnect-MgGraph
Write-Host "Sesja zakonczona." -ForegroundColor Cyan
