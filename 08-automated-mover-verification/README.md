## 🔒 The Problem: Privilege Creep in the Identity Lifecycle (Mover Process)

In enterprise IT environments, managing the Identity Lifecycle—specifically the **Mover** phase (when an employee changes positions, receives a promotion, or transfers between departments)—presents a critical security challenge. 

The root of the problem lies in the operational disconnect between corporate HR systems and technical Identity Providers like Active Directory. When an internal department change occurs:
1. **HR updates the user's business profile** (e.g., changing the text attribute `Department` from *Marketing* to *IT*).
2. **IT Support grants new access rights** required for the employee's new technical responsibilities.
3. **The Gap:** Obsolete access rights from the previous department are rarely revoked automatically, because Active Directory security groups do not natively bind or sync themselves to static text attributes like `Department`.

This accumulation of residual, unnecessary permissions is known as **Privilege Creep**. It directly violates the **Principle of Least Privilege (PoLP)**, turning compromised user accounts into high-risk vectors for lateral movement and expanding the organization's internal attack surface.

### 🛠️ The Identity Governance Control
This project implements an automated, detective compliance control to bridge the gap between organizational structure and technical authorization. 

By enforcing a strict **Role-Based Naming Convention** for Active Directory objects (e.g., `DepartmentName-ResourceName`), the infrastructure allows for automated pattern matching. The control mechanism dynamically cross-references a user's authoritative business department against their effective group memberships, flagging cross-departmental access anomalies and logging them into an audit-ready security report for immediate remediation.