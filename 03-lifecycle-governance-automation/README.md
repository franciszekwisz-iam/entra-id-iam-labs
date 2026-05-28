# Module 03: Lifecycle Governance Automation (Joiner Process)

## Project Overview
This module demonstrates the automation of the **Joiner** phase within the Identity Lifecycle Management process. It simulates an HR-driven provisioning workflow where user identities are bulk-created programmatically in Microsoft Entra ID based on a standardized data export from a human resources system.

## Repository Structure
- `HR_Joiners.csv`: The identity source file simulating the HR data feed, containing core employee attributes (Identity data, department, job title, and initial configurations).
- `New-EntraUsersBulk.ps1`: An automation script utilizing the `Microsoft.Graph` PowerShell module to parse the identity source file, validate attributes, programmatically provision user accounts, and assign initial default safety configurations.

## Implemented Logic
1. **Data Ingestion**: Reads and parses the identity attributes from the CSV source file.
2. **Account Provisioning**: Automatically generates User Principal Names (UPNs), initial temporary passwords, and provisions the cloud identities directly via Microsoft Graph API.
3. **Audit Readiness**: Enforces standardized structural mapping of identity attributes to ensure data consistency across the tenant for future lifecycle states (Movers/Leavers).
