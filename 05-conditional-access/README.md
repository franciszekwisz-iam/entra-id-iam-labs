# Module 05: Conditional Access - Policy Management

## Project Objective
Deploy and validate a Conditional Access policy to enforce Multi-Factor Authentication (MFA) for cloud application access, effectively mitigating the risk of unauthorized access and credential-based attacks.

## Policy Configuration: App_Access_MFA_Required
- **Assignments:** All users
- **Target resources:** Selected cloud apps (e.g., Office 365 / Bing)
- **Access controls:** Require multi-factor authentication (Require MFA)
- **State:** `Report-only` (Audit mode)

## Validation and Testing (What If Tool)
Prior to enforcing the policy, I utilized the **What If** simulation tool within Microsoft Entra ID to verify its behavior for a test user (`Ala Niejaka`) signing in from an Android platform.

The screenshot below confirms that the policy correctly triggers under the specified conditions (`Policies that will apply`) in report-only mode, ensuring zero impact on user productivity during the evaluation phase:

![What If Simulation]
<img width="2552" height="1745" alt="screencapture-entra-microsoft-2026-05-28-20_18_52" src="https://github.com/user-attachments/assets/190932b8-1913-4fc5-86be-fdfe8e127911" />


