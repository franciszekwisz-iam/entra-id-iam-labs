# Moduł 05: Conditional Access - Zarządzanie Dostępem Warunkowym

## Cel projektu
Wdrożenie i przetestowanie polityki Conditional Access (Dostęp Warunkowy) w celu wymuszenia wieloskładnikowego uwierzytelniania (MFA) podczas dostępu do aplikacji firmowych, minimalizując ryzyko nieautoryzowanego dostępu.

## Konfiguracja Polityki: App_Access_MFA_Required
- **Zakres (Assignments):** Wszyscy użytkownicy (All users)
- **Zasoby (Target resources):** Wybrane aplikacje chmurowe (np. Office 365 / Bing)
- **Kontrola dostępu (Access controls):** Wymagaj wieloskładnikowego uwierzytelniania (Require MFA)
- **Stan (State):** `Report-only` (Tryb audytu)

## Walidacja i Testowanie (Narzędzie What If)
Przed aktywacją polityki użyłem narzędzia symulacyjnego **What If** w Microsoft Entra ID, aby zweryfikować jej działanie dla użytkownika testowego (`Ala Niejaka`) logującego się z platformy Android.

Poniższy zrzut ekranu potwierdza, że polityka poprawnie kwalifikuje się do uruchomienia (`Policies that will apply`) w trybie raportu bez przerywania pracy użytkownika:

![Symulacja What If]
<img width="2552" height="1745" alt="screencapture-entra-microsoft-2026-05-28-20_18_52" src="https://github.com/user-attachments/assets/bb18829f-5537-4195-9860-70e0b106df78" />

