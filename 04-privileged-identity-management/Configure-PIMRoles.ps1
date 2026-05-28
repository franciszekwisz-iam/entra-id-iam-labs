# Połączenie z Graph API dla PIM
Connect-MgGraph -Scopes "RoleManagement.Read.Directory", "PrivilegedAccess.Read.AzureAD"

# Pobranie definicji ról i przypisań PIM dla Entra ID
Write-Host "Pobieranie konfiguracji ról PIM..." -ForegroundColor Cyan

$PimAssignments = Get-MgRoleManagementDirectoryRoleAssignmentSchedule -Filter "status eq 'Provisioned'" -ExpandProperty "RoleDefinition,Principal"

# Wyświetlenie ról w czytelny sposób
$PimAssignments | Select-Object `
    @{Name="Użytkownik";Expression={$_.Principal.DisplayName}},
    @{Name="Adres UPN";Expression={$_.Principal.UserPrincipalName}},
    @{Name="Rola Entra ID";Expression={$_.RoleDefinition.DisplayName}},
    @{Name="Typ Przypisania";Expression={$_.AssignmentType}} | Format-Table -AutoSize