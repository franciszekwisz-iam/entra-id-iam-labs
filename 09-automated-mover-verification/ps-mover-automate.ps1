# 1. Pobieramy użytkowników z uzupełnionym działem
$AllUsers = Get-ADUser -Filter "Department -like '*'" -Properties MemberOf, Department

$Report = @()
# Lista wszystkich działów, które sprawdzamy we wzorcach grup
$AllDepartments = @("Marketing", "IT", "Finance", "HR")

foreach ($User in $AllUsers) {
    $CurrentDept = $User.Department # Np. "IT"
    
    # 2. Przeglądamy grupy użytkownika
    foreach ($GroupDN in $User.MemberOf) {
        
        # Wyciągamy samą nazwę grupy z formatu CN=...
        if ($GroupDN -match "CN=(?<GroupName>[^,]+)") {
            $GroupName = $Matches['GroupName']
            
            # 3. Szukamy konfliktów z innymi działami
            foreach ($Dept in $AllDepartments) {
                if ($Dept -ne $CurrentDept) {
                    
                    # Jeśli nazwa grupy zaczyna się od "NazwaInnegoDziału-"
                    if ($GroupName -like "$Dept-*") {
                        
                        $Anomaly = [PSCustomObject]@{
                            SamAccountName = $User.SamAccountName
                            CurrentDept    = $CurrentDept
                            ConflictGroup  = $GroupName
                            CheckDate      = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
                        }
                        $Report += $Anomaly
                        
                        Write-Host "ALERT: Pracownik działu $CurrentDept ($($User.SamAccountName)) posiada grupę: $GroupName" -ForegroundColor Red
                    }
                }
            }
        }
    }
}

# 4. Zapis do pliku CSV na dysku C:\
if ($Report.Count -gt 0) {
    if (-not (Test-Path "C:\IAM_Logs")) { [void](New-Item -ItemType Directory -Path "C:\IAM_Logs") }
    $Report | Export-Csv -Path "C:\IAM_Logs\iam_dynamic_conflicts.csv" -NoTypeInformation -Append
    Write-Host "Wyniki zapisano do C:\IAM_Logs\iam_dynamic_conflicts.csv" -ForegroundColor Green
} else {
    Write-Host "Brak konfliktów uprawnień." -ForegroundColor Green
}