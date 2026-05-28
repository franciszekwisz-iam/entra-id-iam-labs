# Module 04: Privileged Identity Management (PIM) for Entra ID Roles

## Project Overview
This module demonstrates the implementation of a **Just-In-Time (JIT)** access model for highly privileged directory roles within Microsoft Entra ID. The goal is to enforce the principle of least privilege, eliminate standing access, and provide auditing capabilities for administrative actions.

## Implemented Architecture
- **Eligible Assignments**: Administrative roles (e.g., Global Administrator, Helpdesk Administrator) are designated as "Eligible" rather than "Active", requiring explicit activation.
- **Activation Safeguards**:
  - **Multi-Factor Authentication (MFA)** enforcement prior to activation.
  - Mandatory business justification and ticketing system reference.
  - Maximum activation duration capped at **2 hours**.
  - **Approval Workflow**: High-tier roles (like Global Administrator) require explicit peer approval before activation.

## Automation & Reporting
The included PowerShell script (`Configure-PIMRoles.ps1`) utilizes the `Microsoft.Graph.Identity.Governance` module to dynamically audit and export current PIM assignment schedules, validating the tenant's security posture and compliance state.