# Block 3: Modern Authentication and Enterprise SSO Labs

This section documents my practical hands-on experience and theoretical understanding of Modern Authentication protocols, Single Sign-On (SSO), and Identity Federation within Microsoft Entra ID.

---

## Lab 3.1: Identity Architecture Foundations (IdP vs SP)

### 1. Theoretical Concepts (Interview QA)
* **Authentication (AuthN) vs. Authorization (AuthZ):** * *AuthN* is the process of verifying **who you are** (e.g., passwords, MFA prompts).
    * *AuthZ* is the process of verifying **what you can do** (e.g., RBAC roles, application permissions).
* **Identity Provider (IdP):** The central authority that manages digital identities, authenticates users, and issues security tokens (e.g., Microsoft Entra ID).
* **Service Provider (SP):** The external application or resource server (e.g., GitHub, Slack, Salesforce) that relies on the IdP to authenticate users.

### 2. Lab Implementation & Verification
I have initialized the Entra ID tenant and navigated to the Enterprise Applications blade. This section acts as the central hub where Entra ID (functioning as the IdP) establishes trust relationships with external Service Providers (SPs).

* **Path:** `Microsoft Entra admin center` -> `Identity` -> `Applications` -> `Enterprise applications`

*<img width="2553" height="956" alt="image" src="https://github.com/user-attachments/assets/5cbd7362-d462-448d-b15d-4d08e9c1231e" />*
