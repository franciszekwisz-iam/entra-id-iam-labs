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
---

## Lab 3.3: OAuth 2.0 Protocol & JWT Token Anatomy

### 1. Theoretical Concepts 
* **OAuth 2.0 Purpose:** It is strictly an **Authorization (AuthZ)** framework designed to grant applications limited access to user accounts/APIs. It is **not** designed or used for user authentication.
* **JWT (JSON Web Token) Structure:** Composed of three distinct parts separated by dots (`.`):
    * *Header:* Specifies the token type and cryptographic signing algorithm.
    * *Payload (Claims):* Contains the core data, such as token metadata, user context, and granted privileges.
    * *Signature:* Formed by signing the header and payload using a private key to guarantee tamper-proof security.
* **Access vs. Refresh Tokens:**
    * *Access Token:* Short-lived cryptographic string presented to APIs for instant resource access.
    * *Refresh Token:* Long-lived credential used exclusively to request subsequent Access Tokens without forcing user re-authentication.

### 2. Lab Implementation & Verification
I utilized the Microsoft `jwt.ms` deep-decoder engine to dissect a standard enterprise JSON Web Token (JWT) and evaluate its structural security claims.

* **Critical Claims Identified:**
    * `iss` (Issuer): Confirms the specific Identity Provider authority that minted the token.
    * `aud` (Audience): Restricts token usage to the intended target resource API.
    * `exp` (Expiration): Enforces token lifecycle constraints by defining a strict UNIX timestamp boundary.
    * `scp`/`roles` (Scopes/Permissions): Lists the granular API capabilities granted to the holder.
    * <img width="1035" height="1119" alt="image" src="https://github.com/user-attachments/assets/c2553331-8405-4e81-8270-51c9fda0320e" />*
---

## Lab 3.4: OpenID Connect (OIDC) & Discovery Endpoint

### 1. Theoretical Concepts 
* **What is OpenID Connect (OIDC)?** OIDC is an identity layer built on top of the OAuth 2.0 framework. While OAuth 2.0 provides an *Access Token* for authorization, OIDC introduces an **ID Token** (specifically formatted as a JWT) to handle **Authentication (AuthN)**, telling the application exactly who the logged-in user is.
* **The `.well-known` Configuration Endpoint:** In OIDC, instead of manually exchanging massive XML metadata files (like in SAML), identity providers expose a standardized, public JSON document at a well-known path (`/.well-known/openid-configuration`). 
* **Dynamic Configuration & `jwks_uri`:** Applications read this JSON document dynamically to discover login endpoints, token endpoints, and most importantly, the `jwks_uri`. The `jwks_uri` contains the public keys required to verify the cryptographic signatures of incoming JWT tokens instantly.

### 2. Lab Implementation & Verification
I extracted the OpenID Connect metadata document endpoint from the App Registrations blade in Microsoft Entra ID and inspected the live JSON configuration payload.

* **Key endpoints verified in the JSON payload:**
    * `authorization_endpoint`: The target location where users are redirected for interactive authentication.
    * `token_endpoint`: The API endpoint where applications exchange authorization codes for access and ID tokens.
    * `jwks_uri`: The endpoint exposing public signing certificates used for token signature validation.
    * <img width="1843" height="278" alt="image" src="https://github.com/user-attachments/assets/b1702588-1519-45c7-be99-70beded6cfe3" />
