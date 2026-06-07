# 1. Idziemy do chmury i pobieramy całą listę teczek pracowników HR
# Zapisujemy tę całą stertę do jednej zbiorczej szuflady o nazwie $ludzieZHR
$ludzieZHR = Get-MgUser -Filter "department eq 'HR'" -All

# 2. Wołamy naszego pracownika (foreach) i otwieramy stertę z szuflady $ludzieZHR
# Dla KAŻDEGO ($czlowiek) z tej sterty wykonamy instrukcje w nawiasach { }
foreach ($czlowiek in $ludzieZHR) {
    
    # Wyświetlamy w terminalu komunikat, żebyśmy wiedzieli, co skrypt akurat robi
    Write-Host "Aktualizuję użytkownika: $($czlowiek.DisplayName)" -ForegroundColor Cyan
    
    # Podchodzimy do chmury i modyfikujemy dane konkretnego człowieka, używając jego ID
    Update-MgUser -UserId $czlowiek.Id -CompanyName "IAMLab Global Enterprise"
}

# 3. Na koniec wyświetlamy ładny komunikat o sukcesie
Write-Host "Zadanie wykonane! Wszyscy pracownicy HR zaktualizowani." -ForegroundColor Green