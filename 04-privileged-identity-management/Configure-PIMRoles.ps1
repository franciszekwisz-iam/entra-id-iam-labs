# Połączenie z Graph API dla PIM
Connect-MgGraph -Scopes "RoleManagement.Read.Directory", "PrivilegedAccess.Read.AzureAD"

# Pobranie definicji ról i przypisań PIM dla Entra ID
Write-Host "Pobieranie konfiguracji ról PIM..." -ForegroundColor Cyan

# Pobranie definicji ról
$PimAssignments = Get-MgRoleManagementDirectoryRoleAssignmentSchedule -Filter "status eq 'Provisioned'"

# Przetwarzanie i wyświetlanie
$Report = foreach ($Assignment in $PimAssignments) {
    # Pobieramy szczegóły użytkownika na podstawie ID (PrincipalId)
    $User = Get-MgUser -UserId $Assignment.PrincipalId -ErrorAction SilentlyContinue
    $Role = Get-MgRoleManagementDirectoryRoleDefinition -UnifiedRoleDefinitionId $Assignment.RoleDefinitionId

    [PSCustomObject]@{
        "Użytkownik"       = if ($User) { $User.DisplayName } else { "Nieznany/Grupa" }
        "Adres UPN"        = if ($User) { $User.UserPrincipalName } else { $Assignment.PrincipalId }
        "Rola Entra ID"    = $Role.DisplayName
        "Typ Przypisania"  = $Assignment.AssignmentType
    }
}

$Report | Format-Table -AutoSize