# SAML 2.0 Configuration (Microsoft Entra ID) in Keycloak

This document provides a comprehensive, step-by-step guide for configuring an additional Identity Provider based on the SAML 2.0 protocol. This setup runs concurrently with the existing OIDC authentication method within a single Keycloak Realm, allowing users to choose their preferred login method.

---

## 1. Keycloak Pre-Configuration (Service Provider)

Before configuring Microsoft Entra ID, you need to initiate the setup in Keycloak to generate the required endpoints and define your unique application identifiers.

### Step-by-Step Instructions:
1. Log in to your **Keycloak Admin Console**.
2. Select your target Realm (in this setup: `Moj-Lab-IT`) from the top-left dropdown menu.
3. In the left-hand navigation menu, click on **Identity Providers**.
4. Click the **Add provider** dropdown and select **SAML v2.0**.
5. Set the **Alias** field to `saml_ENTRA`. 
6. Scroll down to look at the auto-generated configuration parameters. Keep this tab open, as you will need to copy these values into the Azure Portal.

### Used Parameters:
*   **Alias:** `saml_ENTRA` *(This custom alias defines the unique endpoint path. Changing this from the default 'saml' directly affects the Redirect URL).*
*   **Service provider entity ID:** `http://localhost:8080/realms/Moj-Lab-IT` *(The global identifier for your Keycloak instance).*
*   **Redirect URI (Assertion Consumer Service URL):** `http://localhost:8080/realms/Moj-Lab-IT/broker/saml_ENTRA/endpoint` *(The exact location where Microsoft Entra ID must send the secure SAML tokens).*

---

## 2. Microsoft Entra ID Setup (Identity Provider)

With Keycloak's parameters ready, you must now register Keycloak as an Enterprise Application inside your Microsoft Entra ID tenant.

### Step-by-Step Instructions:
1. Log in to the **Microsoft Entra admin center** (Azure Portal).
2. Navigate to **Identity** -> **Applications** -> **Enterprise applications** -> **All applications**.
3. Click **New application**, then select **Create your own application**.
4. Enter a descriptive name (e.g., `Keycloak SAML Moj-Lab`) and choose the option: **Integrate any other application you don't find in the gallery (Non-gallery)**. Click **Create**.
5. Once the application loads, go to **Manage** -> **Single sign-on** from the left menu, and select **SAML**.
6. In the **Basic SAML Configuration** box, click **Edit** and carefully paste the values from Keycloak:
    *   **Identifier (Entity ID):** Paste the *Service provider entity ID* from Keycloak and check the **Default** box.
    *   **Reply URL (Assertion Consumer Service URL):** Paste the exact *Redirect URI* from Keycloak and check the **Default** box.
7. Click **Save** in the top-left corner.
8. Scroll down to Section 3 (**SAML Certificates**) and copy the **App Federation Metadata URL**.
9. Go back to your open Keycloak tab, find the **SAML entity descriptor** field, paste the copied Metadata URL, and click **Add** at the bottom of the page to save the provider.

### Configuration Visual Reference:
*   **Identifier (Entity ID):** `http://localhost:8080/realms/Moj-Lab-IT`
*   **Reply URL (ACS URL):** `http://localhost:8080/realms/Moj-Lab-IT/broker/saml_ENTRA/endpoint`

*\*Critical Note: If the custom alias `saml_ENTRA` in Keycloak does not exactly match the path in the Azure Reply URL field, authentication will fail with error `AADSTS50011`.*

---

## 3. User Attribute Mapping (Mappers)

By default, Keycloak creates user accounts using a generic random identifier. To automatically populate user profiles with their actual names and email addresses upon their first login, you must configure Mappers.

### Step-by-Step Instructions:
1. In Keycloak, go to **Identity Providers** and click on your newly created `saml_ENTRA` provider.
2. Click on the **Mappers** tab at the top of the provider configuration screen.
3. Click **Add mapper** for each of the three required attributes below. Fill out the form exactly as specified, then click **Save**.

### Required Mappers Configuration:

#### 1. Email Mapper
*   **Name:** `Email`
*   **Mapper Type:** `Attribute Importer`
*   **Attribute Name:** `http://xmlsoap.org` *(Standard Microsoft claim URI for emails)*
*   **User Attribute Name:** `email`

#### 2. First Name Mapper
*   **Name:** `FirstName`
*   **Mapper Type:** `Attribute Importer`
*   **Attribute Name:** `http://xmlsoap.org` *(Standard Microsoft claim URI for first names)*
*   **User Attribute Name:** `firstName`

#### 3. Last Name Mapper
*   **Name:** `LastName`
*   **Mapper Type:** `Attribute Importer`
*   **Attribute Name:** `http://xmlsoap.org` *(Standard Microsoft claim URI for last names)*
*   **User Attribute Name:** `lastName`

---

## 4. Security & Environment Considerations

### Is it safe that these URLs are publicly visible?
**Yes.** According to the SAML 2.0 specification, these endpoints are public by design. They contain zero sensitive data, passwords, or cryptographic secrets. Security is enforced through:
*   **Cryptographic Signatures:** Keycloak will completely reject any incoming SAML tokens unless they are digitally signed by Microsoft's private key.
*   **Strict Whitelisting:** Microsoft Entra ID will absolutely refuse to send login tokens to any URL that hasn't been explicitly listed in the Azure Portal's *Reply URL* whitelist.

### Production Environment Requirements:
When transitioning this system from a local laboratory (`localhost`) to a live production server, you must ensure the following changes are implemented:
1.  **Enforce HTTPS:** All URLs must be updated from `http://` to `https://`. SAML tokens passing through unencrypted HTTP can be intercepted via man-in-the-middle attacks.
2.  **Domain Migration:** Update the hostname from `localhost:8080` to your official public domain (e.g., `https://yourcompany.com`). You will need to update this address in **both** Keycloak settings and the Azure Basic SAML Configuration.

---
*Configuration Status: Fully verified and operational. Users successfully authenticate via Microsoft Entra ID, and their profiles automatically provision into Keycloak during their first login session.*
![SAML](image.png)