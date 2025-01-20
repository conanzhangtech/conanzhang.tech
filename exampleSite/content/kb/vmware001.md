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

> VMWare is still my first choice

#### KB ID

VMWARE001

#### Overview
This comprehensive guide provides detailed instructions on replacing the default self-signed SSL certificate on a vCenter Server Appliance (vSphere) with a Certificate Authority (CA)-signed certificate issued by a Domain Controller. 

Leveraging vSphere's inbuilt GUI certificate manager, the process includes exporting Certificate Signing Requests (CSRs), configuring the Domain Controller CA to issue certificates, importing the signed certificates, and updating the vCenter Server settings.

#### Table of Contents  

1. [Goals](kb/vmware001/#goals)

2. [Why Replace the Default SSL Certificate?](kb/vmware001/#why-replace-the-default-ssl-certificate)  
   2.1 [Benefits of Using a Domain Controller CA-signed Certificate](kb/vmware001/#benefits-of-using-a-domain-controller-ca-signed-certificate)

3. [UAT Scenario](kb/vmware001/#uat-scenario)

4. [Expected Downtime for User](kb/vmware001/#expected-downtime-for-user)

5. [Prerequisites](kb/vmware001/#prerequisites)

6. [Step 1: Take a Snapshot of Your VCSA VM](kb/vmware001/#step-1-take-a-snapshot-of-your-vcsa-vm)  
   6.1 [Step 1a: Log in to your vSphere](kb/vmware001/#step-1a-log-in-to-your-vsphere)  
   6.2 [Step 1b: Take a snapshot of your VCSA VM](kb/vmware001/#step-1b-take-a-snapshot-of-your-vcsa-vm)

7. [Step 2: Create and Issue a Certificate Template for Web Enrollment](kb/vmware001/#step-2-create-and-issue-a-certificate-template-for-web-enrollment)  
   7.1 [Step 2a: Log in to your Windows Server installed with the Certificate Authority role](kb/vmware001/#step-2a-log-in-to-your-windows-server-installed-with-the-certificate-authority-role)  
   7.2 [Step 2b: Launch Certificate Authority](kb/vmware001/#step-2b-launch-certificate-authority)  
   7.3 [Step 2c: Launch Certificate Template Console](kb/vmware001/#step-2c-launch-certificate-template-console)  
   7.4 [Step 2d: Create and Issue a New Certificate Template that is Compatible with vSphere](kb/vmware001/#step-2d-create-and-issue-a-new-certificate-template-that-is-compatible-with-vsphere)  
   7.5 [Step 2e: Change the Permission of the Newly Issued Certificate Template so that it can be Used to Enroll in the Web Enrollment](kb/vmware001/#step-2e-change-the-permission-of-the-newly-issued-certificate-template-so-that-it-can-be-used-to-enroll-in-the-web-enrollment)

8. [Step 3: Generate CSR from the vSphere Certificate Manager GUI and Generate a Certificate to be Used in the vSphere Client](kb/vmware001/#step-3-generate-csr-from-the-vsphere-certificate-manager-gui-and-generate-a-certificate-to-be-used-in-the-vsphere-client)  
   8.1 [Step 3a: Generate CSR](kb/vmware001/#step-3a-generate-csr)  
   8.2 [Step 3b: Import the CSR into the Web Enrollment URL, and Download the Base64 Certificate, and Download and Convert the Domain Controller Certificate Chain into Base64 from the CA](kb/vmware001/#step-3b-import-the-csr-into-the-web-enrollment-url-and-download-the-base64-certificate-and-download-and-convert-the-domain-controller-certificate-chain-into-base64-from-the-ca)

9. [Step 4: Import the CA SSL Certificate and CA Chain Certificate into vSphere](kb/vmware001/#step-4-import-the-ca-ssl-certificate-and-ca-chain-certificate-into-vsphere)  
   9.1 [Step 4a: Log in to the vSphere Web GUI](kb/vmware001/#step-4a-log-in-to-the-vsphere-web-gui)  
   9.2 [Step 4b: Select "Import and Replace Certificate"](kb/vmware001/#step-4b-select-import-and-replace-certificate)  
   9.3 [Step 4c: Browse the respective files](kb/vmware001/#step-4c-browse-the-respective-files)  
   9.4 [Step 4d: Select "I have backed up vCenter Server and its associated database" and click next](kb/vmware001/#step-4d-select-i-have-backed-up-vcenter-server-and-its-associated-database-and-click-next)  
   9.5 [Step 4e: Click Finish](kb/vmware001/#step-4e-click-finish)

10. [Step 5: Verify the Certificate is Now CA Signed](kb/vmware001/#step-5-verify-the-certificate-is-now-ca-signed)

---

11. [Conclusion](kb/vmware001/#conclusion)  
---

12. [Resources](kb/vmware001/#resources)  


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

- Access to a vCenter Server Appliance (vSphere) with administrative privileges (Certificate Manager CLI).
- A Domain Controller with Certificate Authority and IIS Web Enrollment Services Installed.
- Access to Create, View, Edit, and Request Certificate Templates.
- Ability to export and import SSL certificates within the vCenter Server.

---

*I am using vSphere 8, so the interface might look different on yours as compared to mine.*

#### Step 1. Take a snapshot of your VCSA VM.

###### Step 1a: Log in to your vSphere

a. Log in to your vSphere web GUI with your admin credentials.

{{< image src="images/kb/Screenshot 2025-01-20 at 17.47.03.png" command="fill" option="q100" class="img-fluid" >}}

###### Step 1b: Take a snapshot of your VCSA VM.
a. Navigate to the VCSA VM, and go to the snapshots tab.

{{< image src="images/kb/Screenshot 2025-01-20 at 17.48.52.png" command="fill" option="q100" class="img-fluid" >}}

b. Click on "Take Snapshot", uncheck the first option and click "Create"

{{< image src="images/kb/Screenshot 2025-01-20 at 17.51.28.png" command="fill" option="q100" class="img-fluid" >}}

c. Verify that your snapshot has been taken.

{{< image src="images/kb/Screenshot 2025-01-20 at 17.52.54.png" command="fill" option="q100" class="img-fluid" >}}

#### Step 2: Create and issue a certificate template for web enrollment

###### Step 2a: Log in to your Windows Server installed with the Certificate Authority role.

{{< image src="images/kb/Screenshot 2025-01-20 at 20.59.52.png" command="fill" option="q100" class="img-fluid" >}}

###### Step 2b: Launch Certificate Authority

{{< image src="images/kb/Screenshot 2025-01-20 at 21.03.42.png" command="fill" option="q100" class="img-fluid" >}}

###### Step 2c: Launch Certificate Template console

a. Right click on "Certificate Template"

{{< image src="images/kb/Screenshot 2025-01-20 at 21.05.16.png" command="fill" option="q100" class="img-fluid" >}}

b. Select "Manage"

{{< image src="images/kb/Screenshot 2025-01-20 at 21.06.57.png" command="fill" option="q100" class="img-fluid" >}}

c. You should see the Certificate Template console screen.

{{< image src="images/kb/Screenshot 2025-01-20 at 21.09.19.png" command="fill" option="q100" class="img-fluid" >}}

###### Step 2d: Create and Issue a new Certificate Template that is compatible with vSphere.

a. Right click on the "Web Server" Template

{{< image src="images/kb/Screenshot 2025-01-20 at 21.11.49.png" command="fill" option="q100" class="img-fluid" >}}

b. Select "Duplicate Template"

{{< image src="images/kb/Screenshot 2025-01-20 at 21.13.01.png" command="fill" option="q100" class="img-fluid" >}}


c. Navigate to the Compatibility Tab and configure as follows:

<table style="width: 100%; border-collapse: collapse; border: 1px solid black;">
    <tr>
      <th style="border: 1px solid black; padding: 8px; text-align: left; background-color: #f2f2f2; font-weight: bold;">Property</th>
      <th style="border: 1px solid black; padding: 8px; text-align: left; background-color: #f2f2f2; font-weight: bold;">Value</th>
    </tr>
        <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">Compatibility > Compatibility Settings > Certificate Authority and Cerificate Recipient</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">Windows Server 2012 and Windows 7 / Server 2008 R2 <br> {{< image src="images/kb/Screenshot 2025-01-20 at 21.27.13.png" command="fill" option="q100" class="img-fluid" >}}</td>
    </tr>
  </table>

d. Navigate to the Extensions Tab and configure as follows:

<table style="width: 100%; border-collapse: collapse; border: 1px solid black;">
    <tr>
      <th style="border: 1px solid black; padding: 8px; text-align: left; background-color: #f2f2f2; font-weight: bold;">Property</th>
      <th style="border: 1px solid black; padding: 8px; text-align: left; background-color: #f2f2f2; font-weight: bold;">Value</th>
    </tr>
        <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">Extensions > Application Policies > Edit</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">Remove all entries <br> {{< image src="images/kb/Screenshot 2025-01-20 at 21.18.55.png" command="fill" option="q100" class="img-fluid" >}}</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">Extensions > Basic Constraints > Edit</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">Check "Enable this extension" <br> {{< image src="images/kb/Screenshot 2025-01-20 at 21.29.06.png" command="fill" option="q100" class="img-fluid" >}}</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">Extensions > Key Usage > Edit</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">Tick "Signature is proof of origin (nonrepudiation)" and leave the others as default. <br> {{< image src="images/kb/Screenshot 2025-01-20 at 21.32.01.png" command="fill" option="q100" class="img-fluid" >}}</td>
    </tr>
  </table>

e. Navigate to the General Tab and configure as follows:

<table style="width: 100%; border-collapse: collapse; border: 1px solid black;">
    <tr>
      <th style="border: 1px solid black; padding: 8px; text-align: left; background-color: #f2f2f2; font-weight: bold;">Property</th>
      <th style="border: 1px solid black; padding: 8px; text-align: left; background-color: #f2f2f2; font-weight: bold;">Value</th>
    </tr>
        <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">General</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">Configure it as you deem fit. <br> {{< image src="images/kb/Screenshot 2025-01-20 at 21.36.25.png" command="fill" option="q100" class="img-fluid" >}}</td>
    </tr>
  </table>

f. Navigate back to the Certificate Authority console, and go to Certificate Template > New > Certificate Template to issue.

{{< image src="images/kb/Screenshot 2025-01-20 at 21.40.19.png" command="fill" option="q100" class="img-fluid" >}}</td>

g. Select the Certificate template that you have created using c-e, and click Ok.

{{< image src="images/kb/Screenshot 2025-01-20 at 21.41.09.png" command="fill" option="q100" class="img-fluid" >}}</td>

h. Select the Certificate template that you have created using c-e, and click Ok.

{{< image src="images/kb/Screenshot 2025-01-20 at 21.41.09.png" command="fill" option="q100" class="img-fluid" >}}</td>

###### Step 2e: Change the permission of the newly issued Certificate Template so that it can be used to enroll in the Web Enrollment.

*For ease of deployment, I am giving Full Control to "Everyone", PLEASE DO NOT FOLLOW THIS AS IT IS NOT RECOMMENDED!*

a. Right click on the new template in the "Certificate Template Console" and select "Properties".

{{< image src="images/kb/Screenshot 2025-01-20 at 21.47.00.png" command="fill" option="q100" class="img-fluid" >}}

b. Go to Security, and add "Everyone", and give "Full Control"

{{< image src="images/kb/Screenshot 2025-01-20 at 21.51.11.png" command="fill" option="q100" class="img-fluid" >}}


#### Step 3: Generate CSR from the vSphere Certificate Manager GUI and generate a certificate to be used in the vSphere Client.

###### Step 3a: Generate CSR

a. Log in to your vSphere web UI, and navigate to Administration > Certificate Management

{{< image src="images/kb/Screenshot 2025-01-20 at 21.59.37.png" command="fill" option="q100" class="img-fluid" >}}

b. Select "Generate Certificate Signing Request (CSR)"

{{< image src="images/kb/Screenshot 2025-01-20 at 22.02.00.png" command="fill" option="q100" class="img-fluid" >}}

c. Select "Generate Certificate Signing Request (CSR)"

{{< image src="images/kb/Screenshot 2025-01-20 at 22.02.00.png" command="fill" option="q100" class="img-fluid" >}}

d. Enter the following value as per your server: The contents are editable.

<table style="width: 100%; border-collapse: collapse; border: 1px solid black;">
    <tr>
      <th style="border: 1px solid black; padding: 8px; text-align: left; background-color: #f2f2f2; font-weight: bold;">Property</th>
      <th style="border: 1px solid black; padding: 8px; text-align: left; background-color: #f2f2f2; font-weight: bold;">Value</th>
    </tr>
        <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">Common name</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">fortress.conanzhang.tech</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">Organization</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">Facets of Conan ZHANG</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">Organization Unit</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">IT</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">Country</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">Singapore</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">State/Province</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">SG</td>
    </tr>
      <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">Locality</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">SG</td>
    </tr>
      <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">Email Address</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">DataProtection@conanzhang.tech</td>
    </tr>
        </tr>
      <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">Host</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">fortress.conanzhang.tech</td>
    </tr>
        </tr>
      <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">Subject Alternative Name</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">fortress, fortress.tech.conanzhang, tech.conanzhang, 10.10.20.252</td>
    </tr>
          <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">Key Size</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">2048</td>
    </tr>
  </table>

e: Copy / download the CSR

###### Step 3b: Import the CSR into the Web Enrollment URL, and download the Base64 certificate, and download and convert the Domain Controller Ceriifcate Chain into Base64 from the CA. 

a. Navigate to https://<ca-url>/certsrv/certrqxt.asp

{{< image src="images/kb/Screenshot 2025-01-20 at 22.18.35.png" command="fill" option="q100" class="img-fluid" >}}

b. Paste your CSR and click submit

{{< image src="images/kb/Screenshot 2025-01-20 at 22.23.20.png" command="fill" option="q100" class="img-fluid" >}}

c. Select "Base 64 encoded" and download certificate (NOT CERTIFICATE CHAIN)"

{{< image src="images/kb/Screenshot 2025-01-20 at 22.24.24.png" command="fill" option="q100" class="img-fluid" >}}

d. Navigate to https://<ca-url>/certsrv/certcarc.asp and click "Download CA certificate Chain" with Base 64 Encoding.

{{< image src="images/kb/Screenshot 2025-01-20 at 22.27.40.png" command="fill" option="q100" class="img-fluid" >}}

e. Navigate to https://<ca-url>/certsrv/certcarc.asp and click "Download CA certificate Chain" with Base 64 Encoding.

{{< image src="images/kb/Screenshot 2025-01-20 at 22.27.40.png" command="fill" option="q100" class="img-fluid" >}}

f. Open the newly downloaded .p7b file, and navigate into the folders until you find a certificate.

{{< image src="images/kb/Screenshot 2025-01-20 at 22.29.35.png" command="fill" option="q100" class="img-fluid" >}}

g. Export all certificates in the chain by right clicking > All Tasks > Export

{{< image src="images/kb/Screenshot 2025-01-20 at 22.30.21.png" command="fill" option="q100" class="img-fluid" >}}

h. Click next, check the option "Base-64 encoded X.509 (.CER)" option and click next

{{< image src="images/kb/Screenshot 2025-01-20 at 22.32.42.png" command="fill" option="q100" class="img-fluid" >}}

i. Select the location of the .cer chain file, and click next

{{< image src="images/kb/Screenshot 2025-01-20 at 22.33.30.png" command="fill" option="q100" class="img-fluid" >}}

j. Verify the information, and click Finish

{{< image src="images/kb/Screenshot 2025-01-20 at 22.34.56.png" command="fill" option="q100" class="img-fluid" >}}

#### Step 4: Import the CA SSL certificate and CA Chain certificate into vSphere

###### Step 4a: Log in to the vSphere Web GUI

a. Log in to your vSphere web UI, and navigate to Administration > Certificate Management

{{< image src="images/kb/Screenshot 2025-01-20 at 21.59.37.png" command="fill" option="q100" class="img-fluid" >}}

b. Select "Generate Certificate Signing Request (CSR)"

{{< image src="images/kb/Screenshot 2025-01-20 at 22.02.00.png" command="fill" option="q100" class="img-fluid" >}}

c. Select "Import and Replace Certificate"

{{< image src="images/kb/Screenshot 2025-01-20 at 22.41.13.png" command="fill" option="q100" class="img-fluid" >}}

d. Select "Replace with External CA certificate where CSR ....."

{{< image src="images/kb/Screenshot 2025-01-20 at 22.43.44.png" command="fill" option="q100" class="img-fluid" >}}

e. Browse the respective files

<table style="width: 100%; border-collapse: collapse; border: 1px solid black;">
    <tr>
      <th style="border: 1px solid black; padding: 8px; text-align: left; background-color: #f2f2f2; font-weight: bold;">Property</th>
      <th style="border: 1px solid black; padding: 8px; text-align: left; background-color: #f2f2f2; font-weight: bold;">Value</th>
    </tr>
        <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">Machine SSL Certificate</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">Use the file download in 3b (c) <br> 
      
      c. Select "Base 64 encoded" and download certificate (NOT CERTIFICATE CHAIN)"

{{< image src="images/kb/Screenshot 2025-01-20 at 22.24.24.png" command="fill" option="q100" class="img-fluid" >}}</td>
    </tr>
    <tr>
      <td style="border: 1px solid black; padding: 8px; text-align: left;">Chain of trusted root certificates</td>
      <td style="border: 1px solid black; padding: 8px; text-align: left;" contenteditable="true">Use the file exported in 3b (i) <br> 
      
i. Select the location of the .cer chain file, and click next

{{< image src="images/kb/Screenshot 2025-01-20 at 22.33.30.png" command="fill" option="q100" class="img-fluid" >}}</td>
    </tr>
  </table>

{{< image src="images/kb/Screenshot 2025-01-20 at 22.56.39.png" command="fill" option="q100" class="img-fluid" >}}

f: Select "I have backed up vCenter Server and its associated database" and click next

{{< image src="images/kb/Screenshot 2025-01-20 at 22.59.15.png" command="fill" option="q100" class="img-fluid" >}}

g: Click Finish

{{< image src="images/kb/Screenshot 2025-01-20 at 23.01.04.png" command="fill" option="q100" class="img-fluid" >}}

#### Step 5: Verify the certificate is now CA Signed

{{< image src="images/kb/Screenshot 2025-01-20 at 23.03.47.png" command="fill" option="q100" class="img-fluid" >}}

#### Conclusion.
By carefully following the steps outlined above, you can successfully reissue a certificate that is CA trusted.

---

#### Resources.
