---
title: "KB - VMWARE001: How to replace a vCenter (vSphere) Server Machine SSL Certificate from self-signed to Domain Controller CA-signed?."

description: "This comprehensive guide provides detailed instructions on replacing the default self-signed SSL certificate on a vCenter Server Appliance (vSphere) with a Certificate Authority (CA)-signed certificate issued by a Domain Controller. 

Leveraging vSphere's inbuilt GUI certificate manager, the process includes exporting Certificate Signing Requests (CSRs), configuring the Domain Controller CA to issue certificates, importing the signed certificates, and updating the vCenter Server settings."

image: "images/kb/How to Cert.png"
date: 2025-01-20
categories: []
type: "featured" # available types: [featured/regular]
draft: false
sitemapExclude: false
---

> It is not as difficult as you would have imagined ^_-.

#### KB ID

MS001

#### Overview
This comprehensive guide provides detailed instructions on replacing the default self-signed SSL certificate on a vCenter Server Appliance (vSphere) with a Certificate Authority (CA)-signed certificate issued by a Domain Controller. 

Leveraging vSphere's inbuilt GUI certificate manager, the process includes exporting Certificate Signing Requests (CSRs), configuring the Domain Controller CA to issue certificates, importing the signed certificates, and updating the vCenter Server settings.

# Table of Contents  

1. [Goals](kb/vmware001/#goals)
   - [Why Replace the Default SSL Certificate?](kb/vmware001/#why-replace-the-default-ssl-certificate)  
   - [Benefits of Using a Domain Controller CA-signed Certificate](kb/vmware001/#benefits-of-using-a-domain-controller-ca-signed-certificate)

2. [UAT Scenario](kb/vmware001/#uat-scenario)



3. [Expected Downtime](kb/vmware001/#expected-downtime)

3. [Prerequisites](kb/vmware001/#prerequisites)  
   - [vSphere GUI Certificate Manager](kb/vmware001/#vsphere-gui-certificate-manager)  
   - [Access to the Domain Controller CA](kb/vmware001/#access-to-the-domain-controller-ca)  
   - [Backup and Recovery Preparation](kb/vmware001/#backup-and-recovery-preparation)

4. [Step-by-Step Process](kb/vmware001/#step-by-step-process)  
   - [Step 1: Export a Certificate Signing Request (CSR)](kb/vmware001/#step-1-export-a-certificate-signing-request-csr)  
   - [Step 2: Issue the Certificate via Domain Controller CA](kb/vmware001/#step-2-issue-the-certificate-via-domain-controller-ca)  
   - [Step 3: Import the CA-signed Certificate into vSphere](kb/vmware001/#step-3-import-the-ca-signed-certificate-into-vsphere)  
   - [Step 4: Update vCenter Server Settings](kb/vmware001/#step-4-update-vcenter-server-settings)  
   - [Step 5: Validate and Verify the Certificate](kb/vmware001/#step-5-validate-and-verify-the-certificate)

5. [Troubleshooting Common Issues](kb/vmware001/#troubleshooting-common-issues)  
   - [CSR Export Errors](kb/vmware001/#csr-export-errors)  
   - [Certificate Import Issues](kb/vmware001/#certificate-import-issues)  
   - [Post-Implementation Connectivity Problems](kb/vmware001/#post-implementation-connectivity-problems)

6. [Conclusion](kb/vmware001/#conclusion)

7. [Resources and References](kb/vmware001/#resources-and-references)



---
#### Goals

The goal of this article is to guide administrators through the process of replacing the default self-signed SSL certificate on a vCenter Server Appliance with a Domain Controller CA-signed certificate.

###### Why Replace the Default SSL Certificate?
The default self-signed SSL certificate on vCenter Server is not trusted by other systems. Replacing it with a CA-signed certificate enhances security, ensures trust, and complies with organisational policies, while enabling seamless integration with domain services.

###### Benefits of Using a Domain Controller CA-signed Certificate
- **Trust**: Trusted by all major systems and browsers.  
- **Security**: Provides stronger encryption and protection.  
- **Compliance**: Meets security standards and regulations.  
- **Integration**: Ensures smooth compatibility with Active Directory and network services.

---

#### UAT Scenario
*Assuming that vCenter Server has been deployed and Certificate Authority and its web services roles have been installed*

In this scenario:

**Characters:**

- **Xiao Ming (IT Administrator)** – Responsible for managing the vCenter and CA server and ensuring the security of the VMware infrastructure.
- **Da Ming (Manager)** – Focuses on maintaining security compliance across the organisation.

---

**Initial Discussion**

**Xiao Ming**: *"Da Ming, our VAPT report shows flagged out that our vCenter Server is still using the default self-signed SSL certificate. We need to replace it with a Domain Controller CA-signed certificate to improve security and ensure compliance."*

**Da Ming**: *"I agree. A self-signed certificate could create security risks and trust issues. I think it is time we implement a trusted CA-signed certificate. Do you have a plan for this?"*

**Xiao Ming**: *"Yes, I have already outlined the steps. First, I will export a CSR from the vCenter Certificate Manager GUI, then we can use the Domain Controller's certificate web enrollment service to issue the CA-signed certificate. After that, I will import it back into vCenter and update the server settings."*

**Da Ming**: *"Great. Make sure to run a few tests to verify the installation is successful and that everything works without disruptions. We don't want any downtime affecting operations."*

---

**Testing and Validation**

*Xiao Ming and Da Ming begin testing the changes.*

**Da Ming**: *"I have verified that the new CA certificate is trusted by the browser and I have tested the login process for all users. So far, no issues with authentication, and everything is loading without certificate errors."*

#### Expected downtime for user.

10 Mins (Depends on how quickily IT Admins perform the steps)

#### Prerequisites
- Access to a x64 bit Windows 10/11 host and have local admin access (x32 bit, ARM devices are NOT supported.)
- Domain Admin access to the respective primary DCs.
- Local Admin access to the respective Entra Connect Servers
- Global Administrator OR Hybrid Identity Administrator and User Administrator
- Install MSOnline Powershell Module

---


#### Solution 1: Softmatch via UserPrincipalName


###### Step 1: Information Gathering (Microsoft Entra ID).
1a. Log in to the [Microsoft Entra ID admin portal](https://entra.microsoft.com) with your admin credentials.

{{< image src="images/kb/Screenshot 2025-01-08 at 23.21.47.png" command="fill" option="q100" class="img-fluid" >}}

1b. Navigate to [Users > AllUsers](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserManagementMenuBlade/~/AllUsers/menuId/) blade and look for the 2 objects: `object1@conanzhang.tech` and `object1anotheridentity@conanzhang.tech`

{{< image src="images/kb/Screenshot 2025-01-08 at 23.31.45.png" command="fill" option="q100" class="img-fluid" >}}

1c: Navigate to each object, and under properties, record down the following (The value is editable, so you can edit it here and copy to your notes, this is client-side processsing, data is NOT sent to my server for processing).:

object1@conanzhang.tech
<table style="width: 100%; border-collapse: collapse; border: 1px solid black;">
    <tr>
      <th style="border: 1px solid black; padding: 8px; text-align: left; background-color: #f2f2f2; font-weight: bold;">Property</th>
      <th style="border: 1px solid black; padding: 8px; text-align: left; background-color: #f2f2f2; font-weight: bold;">Value</th>
    </tr>
        <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">EntraID User principal name</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">object1@conanzhang.tech</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">EntraID Object ID</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">b48bcbb9-945b-4145-9622-7860d0e5a819</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">On-premises sync enabled</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">Yes</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">On-premises immutable ID</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">jWmHz8UnMkCgcoJF/Rl5Xw==</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">On-premises domain name</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">tech.conanzhang</td>
    </tr>
  </table>

<br>

object1anotheridentity@conanzhang.tech
<table style="width: 100%; border-collapse: collapse; border: 1px solid black;">
  <tr>
    <th style="border: 1px solid black; padding: 8px; text-align: left; background-color: #f2f2f2; font-weight: bold;">Property</th>
    <th style="border: 1px solid black; padding: 8px; text-align: left; background-color: #f2f2f2; font-weight: bold;">Value</th>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 8px; text-align: left;">EntraID User principal name</td>
    <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">object1anotheridentity@conanzhang.tech</td>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 8px; text-align: left;">EntraID Object ID</td>
    <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">61a6e220-21aa-4f06-ba7f-f1b3bff27dae</td>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 8px; text-align: left;">On-premises sync enabled</td>
    <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">Yes</td>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 8px; text-align: left;">On-premises immutable ID</td>
    <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">miLlmU1fMk2U8Mnd2lKzHg==</td>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 8px; text-align: left;">On-premises domain name</td>
    <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">tech.conanzhang.UAT</td>
  </tr>
</table>


###### Step 2: Modify synchronisation setting for the respective Entra Connect Servers.

**You will only need to perform this step if your Entra Connect Server is set to "Sync all domains and OUs" because you will need to move the user to an unsynced OU.** Skip to [Step 3: Move object1 to the unsynchronised OU in DC1 and DC2 respectively.](kb/vmware001/#step-3-move-object1-to-the-unsynchronised-ou-in-dc1-and-dc2-respectively) if your Entra Connect Server is not under this setting.

2a: Remote to the respective Entra Connect Servers with your Adminstrator Account via rdp, bastion or https.

2b: Launch the Azure AD Connect application.

{{< image src="images/kb/Screenshot 2025-01-09 at 00.10.46.png" command="fill" option="q100" class="img-fluid" >}}

2c: Click "Configure".

{{< image src="images/kb/Screenshot 2025-01-09 at 00.12.52.png" command="fill" option="q100" class="img-fluid" >}}

2d: Click "Customise synchronization options" and click "Next".

{{< image src="images/kb/Screenshot 2025-01-09 at 00.14.37.png" command="fill" option="q100" class="img-fluid" >}}

2e: Enter your Microsoft Entra ID Admin credentials, login, and click "Next".

{{< image src="images/kb/Screenshot 2025-01-09 at 00.17.02.png" command="fill" option="q100" class="img-fluid" >}}

2f: Leave all the settings as default and Click "Next" (No image here).

2g: Change the option from "Sync all domains and OUs" to "Sync selected domains and OUs" and untick the OU that you do not wish to synchronise.

{{< image src="images/kb/Screenshot 2025-01-09 at 00.21.14.png" command="fill" option="q100" class="img-fluid" >}}

2h: Leave all the settings as default and Click "Next" (No image here).

2i: Tick the option "start the synchronization process when configuration completes" and click "Configure"

{{< image src="images/kb/Screenshot 2025-01-09 at 00.29.32.png" command="fill" option="q100" class="img-fluid" >}}

2j: Click "Exit" - IMPORTANT

{{< image src="images/kb/Screenshot 2025-01-09 at 00.36.19.png" command="fill" option="q100" class="img-fluid" >}}


###### Step 3: Move object1 to the unsynchronised OU in DC1 and DC2 respectively.

3a. Just move them how you usually does (No image here)

###### Step 4: Run first delta sync in DC1 and DC2 respectively.

This deletes `object1@conanzhang.tech` and `object1anotheridentity@conanzhang.tech`, flipping their "On-premises sync enabled" to "false".

Launch Powershell as administrator, and run the following command.
```powershell
Start-ADSyncSyncCycle -PolicyType Delta
```
{{< image src="images/kb/Screenshot 2025-01-09 at 00.41.55.png" command="fill" option="q100" class="img-fluid" >}}

The users, `object1@conanzhang.tech` and `object1anotheridentity@conanzhang.tech` are now DELETED in Microsft Entra ID

###### Step 5: Restore the deleted user object1@conanzhang.tech from Microsoft Entra ID and verify the current configuration.

5a. Log in to the [Microsoft Entra ID admin portal](https://entra.microsoft.com) with your admin credentials.

{{< image src="images/kb/Screenshot 2025-01-08 at 23.21.47.png" command="fill" option="q100" class="img-fluid" >}}

5b. Navigate to [Users > DeletedUsers](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserManagementMenuBlade/~/DeletedUsers/menuId/DeletedUsers) blade and restore the object `object1@conanzhang.tech`.

{{< image src="images/kb/Screenshot 2025-01-09 at 00.52.39.png" command="fill" option="q100" class="img-fluid" >}}

5c: Once restored, navigate to `object1@conanzhang.tech`, and under properties, ensure that it is the following (The value is editable, so you can edit it here and copy to your notes, this is client-side processsing, data is NOT sent to my server for processing).:

object1@conanzhang.tech
<table style="width: 100%; border-collapse: collapse; border: 1px solid black;">
    <tr>
      <th style="border: 1px solid black; padding: 8px; text-align: left; background-color: #f2f2f2; font-weight: bold;">Property</th>
      <th style="border: 1px solid black; padding: 8px; text-align: left; background-color: #f2f2f2; font-weight: bold;">Value</th>
    </tr>
        <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">EntraID User principal name</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">object1@conanzhang.tech</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">EntraID Object ID</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">b48bcbb9-945b-4145-9622-7860d0e5a819</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">On-premises sync enabled</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">No</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">On-premises immutable ID</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">jWmHz8UnMkCgcoJF/Rl5Xw==</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">On-premises domain name</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">tech.conanzhang</td>
    </tr>
  </table>

<br>


###### Step 6: Remove `object1@conanzhang.tech`'s ImmutableID via MSOnline Powershell.

6a. Run powershell as Administrator, and run the following:

   ```powershell
   Set-ExecutionPolicy bypass
   Install-Module -Name MSOnline
   Import-Module -Name MSOnline
   ```

{{< image src="images/kb/Screenshot 2025-01-09 at 01.02.32.png" command="fill" option="q100" class="img-fluid" >}}

6b. Connect to MSOLservice with your admin credetials.

   ```powershell
connect-msolservice
   ```

{{< image src="images/kb/Screenshot 2025-01-09 at 01.05.50.png" command="fill" option="q100" class="img-fluid" >}}

6c. Run the following and remove the existing ImmutableID from `object1@conanzhang.tech`.

   ```powershell
Get-MsolUser -UserPrincipalName object1@conanzhang.tech | Set-MsolUser -ImmutableId "$null"
   ```

6d: Navigate to `object1@conanzhang.tech`, and under properties, ensure that it is the following (The value is editable, so you can edit it here and copy to your notes, this is client-side processsing, data is NOT sent to my server for processing).:

object1@conanzhang.tech
<table style="width: 100%; border-collapse: collapse; border: 1px solid black;">
    <tr>
      <th style="border: 1px solid black; padding: 8px; text-align: left; background-color: #f2f2f2; font-weight: bold;">Property</th>
      <th style="border: 1px solid black; padding: 8px; text-align: left; background-color: #f2f2f2; font-weight: bold;">Value</th>
    </tr>
        <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">EntraID User principal name</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">object1@conanzhang.tech</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">EntraID Object ID</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">b48bcbb9-945b-4145-9622-7860d0e5a819</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">On-premises sync enabled</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">No</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">On-premises immutable ID</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;"></td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">On-premises domain name</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">tech.conanzhang</td>
    </tr>
  </table>

<br>

###### Step 7: Perform Soft Match.

7a. Navigate to `DC1\object1@conanzhang.tech` object on your AD, and update its UPN, email, SMTP: address to match `object1@conanzhang.tech` on Microsoft Entra ID.

**You may have a different attribute for synchronising UPN, for example, ExtensionAttribute. Update that accordingly.**

###### Step 8: Run second delta sync in DC1. 

This action will replace the ImmutableID to the current user in Location A and linking it to the right user.

Launch Powershell as administrator, and run the following command.
```powershell
Start-ADSyncSyncCycle -PolicyType Delta
```
{{< image src="images/kb/Screenshot 2025-01-09 at 00.41.55.png" command="fill" option="q100" class="img-fluid" >}}

The users `object1@conanzhang.tech` is now synchronised with DC1 instead of DC2.


###### Step 9: Verify that the user's On-Premise ImmutableID and On-premise Domain Name is now changed.

Please compare the table recprded in the previous step.

object1@conanzhang.tech
<table style="width: 100%; border-collapse: collapse; border: 1px solid black;">
    <tr>
      <th style="border: 1px solid black; padding: 8px; text-align: left; background-color: #f2f2f2; font-weight: bold;">Property</th>
      <th style="border: 1px solid black; padding: 8px; text-align: left; background-color: #f2f2f2; font-weight: bold;">Value</th>
    </tr>
        <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">EntraID User principal name</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">object1@conanzhang.tech</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">EntraID Object ID</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">b48bcbb9-945b-4145-9622-7860d0e5a819</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">On-premises sync enabled</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">Yes</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">On-premises immutable ID</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">jWmHz8UnMkCgcoJF/Rl5Xw== (Changed from miLlmU1fMk2U8Mnd2lKzHg==)</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">On-premises domain name</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">tech.conanzhang (Changed from tech.conanzhang.UAT)</td>
    </tr>
  </table>

<br>

#### Solution 2: Hardmatch by forcefully modifying the On premise ImmutableID attribute to the correct one.

**This is not recommended as forcefully matching may result in unexpected behaviours.**

###### Step 1: Information Gathering (Microsoft Entra ID).
1a. Log in to the [Microsoft Entra ID admin portal](https://entra.microsoft.com) with your admin credentials.

{{< image src="images/kb/Screenshot 2025-01-08 at 23.21.47.png" command="fill" option="q100" class="img-fluid" >}}

1b. Navigate to [Users > AllUsers](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserManagementMenuBlade/~/AllUsers/menuId/) blade and look for the 2 objects: `object1@conanzhang.tech` and `object1anotheridentity@conanzhang.tech`

{{< image src="images/kb/Screenshot 2025-01-08 at 23.31.45.png" command="fill" option="q100" class="img-fluid" >}}

1c: Navigate to each object, and under properties, record down the following (The value is editable, so you can edit it here and copy to your notes, this is client-side processsing, data is NOT sent to my server for processing).:

object1@conanzhang.tech
<table style="width: 100%; border-collapse: collapse; border: 1px solid black;">
    <tr>
      <th style="border: 1px solid black; padding: 8px; text-align: left; background-color: #f2f2f2; font-weight: bold;">Property</th>
      <th style="border: 1px solid black; padding: 8px; text-align: left; background-color: #f2f2f2; font-weight: bold;">Value</th>
    </tr>
        <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">EntraID User principal name</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">object1@conanzhang.tech</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">EntraID Object ID</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">b48bcbb9-945b-4145-9622-7860d0e5a819</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">On-premises sync enabled</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">Yes</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">On-premises immutable ID</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">jWmHz8UnMkCgcoJF/Rl5Xw==</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">On-premises domain name</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">tech.conanzhang</td>
    </tr>
  </table>

<br>

object1anotheridentity@conanzhang.tech
<table style="width: 100%; border-collapse: collapse; border: 1px solid black;">
  <tr>
    <th style="border: 1px solid black; padding: 8px; text-align: left; background-color: #f2f2f2; font-weight: bold;">Property</th>
    <th style="border: 1px solid black; padding: 8px; text-align: left; background-color: #f2f2f2; font-weight: bold;">Value</th>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 8px; text-align: left;">EntraID User principal name</td>
    <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">object1anotheridentity@conanzhang.tech</td>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 8px; text-align: left;">EntraID Object ID</td>
    <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">61a6e220-21aa-4f06-ba7f-f1b3bff27dae</td>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 8px; text-align: left;">On-premises sync enabled</td>
    <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">Yes</td>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 8px; text-align: left;">On-premises immutable ID</td>
    <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">miLlmU1fMk2U8Mnd2lKzHg==</td>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 8px; text-align: left;">On-premises domain name</td>
    <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">tech.conanzhang.UAT</td>
  </tr>
</table>


###### Step 2: Replace `object1@conanzhang.tech`'s ImmutableID from miLlmU1fMk2U8Mnd2lKzHg== to jWmHz8UnMkCgcoJF/Rl5Xw== via MSOnline Powershell.

2a. Run powershell as Administrator, and run the following:

   ```powershell
   Set-ExecutionPolicy bypass
   Install-Module -Name MSOnline
   Import-Module -Name MSOnline
   ```

{{< image src="images/kb/Screenshot 2025-01-09 at 01.02.32.png" command="fill" option="q100" class="img-fluid" >}}

2b. Connect to MSOLservice with your admin credetials.

   ```powershell
connect-msolservice
   ```

{{< image src="images/kb/Screenshot 2025-01-09 at 01.05.50.png" command="fill" option="q100" class="img-fluid" >}}

2c. Run the following and remove the existing ImmutableID from `object1@conanzhang.tech`.

   ```powershell
Get-MsolUser -UserPrincipalName object1@conanzhang.tech | Set-MsolUser -ImmutableId "jWmHz8UnMkCgcoJF/Rl5Xw=="
   ```

2d: Navigate to `object1@conanzhang.tech`, and under properties, ensure that it is the following (The value is editable, so you can edit it here and copy to your notes, this is client-side processsing, data is NOT sent to my server for processing).:

object1@conanzhang.tech
<table style="width: 100%; border-collapse: collapse; border: 1px solid black;">
    <tr>
      <th style="border: 1px solid black; padding: 8px; text-align: left; background-color: #f2f2f2; font-weight: bold;">Property</th>
      <th style="border: 1px solid black; padding: 8px; text-align: left; background-color: #f2f2f2; font-weight: bold;">Value</th>
    </tr>
        <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">EntraID User principal name</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">object1@conanzhang.tech</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">EntraID Object ID</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">b48bcbb9-945b-4145-9622-7860d0e5a819</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">On-premises sync enabled</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">No</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">On-premises immutable ID</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">jWmHz8UnMkCgcoJF/Rl5Xw==</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">On-premises domain name</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">tech.conanzhang</td>
    </tr>
  </table>

<br>

###### Step 3: Run delta sync in DC1. 

This action will replace the rebase to the current user in Location A and linking it to the right user.

Launch Powershell as administrator, and run the following command.
```powershell
Start-ADSyncSyncCycle -PolicyType Delta
```
{{< image src="images/kb/Screenshot 2025-01-09 at 00.41.55.png" command="fill" option="q100" class="img-fluid" >}}

The users `object1@conanzhang.tech` is now synchronised with DC1 instead of DC2.


###### Step 4: Verify that the user's On-Premise ImmutableID and On-premise Domain Name is now changed.

Please compare the table recorded in the previous step.

object1@conanzhang.tech
<table style="width: 100%; border-collapse: collapse; border: 1px solid black;">
    <tr>
      <th style="border: 1px solid black; padding: 8px; text-align: left; background-color: #f2f2f2; font-weight: bold;">Property</th>
      <th style="border: 1px solid black; padding: 8px; text-align: left; background-color: #f2f2f2; font-weight: bold;">Value</th>
    </tr>
        <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">EntraID User principal name</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">object1@conanzhang.tech</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">EntraID Object ID</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">b48bcbb9-945b-4145-9622-7860d0e5a819</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">On-premises sync enabled</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">Yes</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">On-premises immutable ID</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">jWmHz8UnMkCgcoJF/Rl5Xw== (Changed from miLlmU1fMk2U8Mnd2lKzHg==)</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">On-premises domain name</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">tech.conanzhang (Changed from tech.conanzhang.UAT)</td>
    </tr>
  </table>

<br>

---

#### Conclusion.
By carefully following the steps outlined above, you can successfully move an on-premises object between Domain Controllers while preserving its hybrid identity in Microsoft Entra ID. Choose Soft Match for non-intrusive updates or Hard Match for scenarios requiring explicit matching.

---

#### Resources.
- [Microsoft Entra ID Documentation](https://learn.microsoft.com/en-us/azure/active-directory/)
- [Azure AD Connect Troubleshooting Guide](https://learn.microsoft.com/en-us/azure/active-directory/hybrid/how-to-connect-sync-errors)
