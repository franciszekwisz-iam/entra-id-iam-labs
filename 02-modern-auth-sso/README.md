# Block 3: Modern Authentication and Enterprise SSO Labs

This section documents my practical hands-on experience and theoretical understanding of Modern Authentication protocols, Single Sign-On (SSO), and Identity Federation within Microsoft Entra ID.

---

## Lab 3.1: Identity Architecture Foundations (IdP vs SP)

### 1. Theoretical Concepts 
* **Authentication (AuthN) vs. Authorization (AuthZ):** * *AuthN* is the process of verifying **who you are** (e.g., passwords, MFA prompts).
    * *AuthZ* is the process of verifying **what you can do** (e.g., RBAC roles, application permissions).
* **Identity Provider (IdP):** The central authority that manages digital identities, authenticates users, and issues security tokens (e.g., Microsoft Entra ID).
* **Service Provider (SP):** The external application or resource server (e.g., GitHub, Slack, Salesforce) that relies on the IdP to authenticate users.

### 2. Lab Implementation & Verification
I have initialized the Entra ID tenant and navigated to the Enterprise Applications blade. This section acts as the central hub where Entra ID (functioning as the IdP) establishes trust relationships with external Service Providers (SPs).

* **Path:** `Microsoft Entra admin center` -> `Identity` -> `Applications` -> `Enterprise applications`

*<img width="2553" height="956" alt="image" src="https://github.com/user-attachments/assets/5cbd7362-d462-448d-b15d-4d08e9c1231e" />*
---

## Lab 3.2: SAML 2.0 Protocol (Enterprise SSO)

### 1. Theoretical Concepts 
* **SAML 2.0 Assertion:** An XML-based token issued by the IdP, cryptographically signed, containing user attributes (*Claims*) and group memberships sent to the Service Provider (SP).
* **Federation Metadata XML:** A configuration file exchanged between IdP and SP to establish an explicit trust relationship. It contains Single Sign-On URLs, Entity IDs, and public keys (certificates).
* **Key Rollover Concept:** Metadata files often contain multiple `<X509Certificate>` tags. This ensures high availability during certificate expiration phases (one active key, one future rolling key) or separates signing functions from encryption functions.
* **SP-initiated vs. IdP-initiated Flows:**
    * *SP-initiated:* The user visits the application directly (e.g., Slack), triggers authentication, gets redirected to Entra ID, and returns with an XML token.
    * *IdP-initiated:* The user logs into `myapps.microsoft.com`, clicks the application tile, and Entra ID crafts the assertion to log the user into the app directly.

### 2. Lab Implementation & Verification
I have provisioned a custom Non-Gallery Enterprise Application named `Test-SAML-Enterprise` to act as a placeholder for SAML SSO federation. I downloaded and inspected the generated **Federation Metadata XML** file to understand how cryptographic trust and public keys are shared.

* **Key elements identified in the XML:**
    * `<X509Certificate>`: Contains the public key used by the SP to verify the cryptographic signature of assertions.
    * `<SingleSignOnService>`: Specifies the explicit Entra ID endpoint where SAML AuthnRequests must be sent.

*<img width="1824" height="915" alt="image" src="https://github.com/user-attachments/assets/0adba110-4e06-4df3-b58d-0d3539966365" />*
