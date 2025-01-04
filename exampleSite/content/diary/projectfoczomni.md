---
title: "Project FOCZOmni: Home Lab Built with Passion by [@conanzhangtech](getintouch)"
description: "#ProjectFOCZOmni is my dedicated home lab environment, developed to simulate and showcases how I build and manage a small-scale IT environment for personal and professional growth. It enables me to explore, learn, and innovate."
image: "images/diary/ProjectFOCZOmni-main.png"
date: 2025-01-03
categories: []
type: "featured" # available types: [featured/regular]
draft: false
sitemapExclude: false
---

> A personal playground for experimentation and innovation.

#### Overview
#ProjectFOCZOmni is my dedicated home lab environment, developed to simulate and showcases how I build and manage a small-scale IT environment for personal and professional growth. It enables me to explore, learn, and innovate.

The homelab also serves as a testing ground me to do Proof-of-Concept before turning ideas into reality.

1. [Goals](diary/projectfoczomni/#goals)
2. [Security and Infrastructure](diary/projectfoczomni/#security-and-infrastructure)
3. [Virtualisation](diary/projectfoczomni/#virtualisation)
4. [Web Applications](diary/projectfoczomni/#web-applications)
5. [Backup](diary/projectfoczomni/#backup)
6. [Future Improvements](diary/projectfoczomni/#future-improvements)

---
#### Goals
- **Self Learning**: Experiment with new technologies and enhance my skills in networking, system administration, and DevOps.  
- **Professional Development**: Host personal projects and explore virtualisation, containerisation, and integration with cloud technologies.  
- **Sharing and Exchange**: Provide and exchange insights and inspiration for others interested in building their own home lab.
---

#### Security and Infrastructure

- **Domain Names I own**:  
  - conanzhang.tech (Purchased from Namecheap)
  - ztcc.ink (Purchased from Namecheap)

- **Information Security Profile**:  
  - Cloudflare for DNS Management
  - Cloudflare Zero Trust for Zero Trust Network Access (ZTNA) implementation
  - Microsoft EntraID for Identity Access Management (IdP)
  - Microsoft Azure Network Gateway as Site-to-Site and Point-to-Site configuration.
  - Nessus for Vulnerability Assessment.

#### Virtualisation

- **Virtualisation Platform**:  

  - VMWare EXSI set up as Type 1 Hypervisor
  - VMWare vSphere (VCSA) set up to manage the ESXI server
---

#### Web Applications

- [**FOCZ - Build Server**](https://build.conanzhang.tech)

It is a self-hosted code server I use to host or run development environments for writing, testing, and deploying code.

For instance, I use it to adjust and control the version of the the source codes used to run applications, APIs, or databases in real-time, such as this website.

I get a web-based version of VS Code and enables me to access my environment from anywhere, making it easier for me to collaborate or work on my projects remotely.

Learn how to [host your own code-server](diary/host-your-own-codeserver) and [publish your first website using Cloudflare Pages, Github and Hugo Builder integration](diary/publish-your-first-website-using-cloudflare-pages-github-and-hugo-builder-integration)!

<br>

- [**FOCZ - Obsidian Server**](https://obsidian.conanzhang.tech)

FOCZ - Obsidian Server is a self-hosted Privileged Access Management (PAM) solution that I use to securely access my **Windows VMs** via **RDP** and **Linux VMs** via **SSH**. 

By centralising access control, it helps me securely manage privileged access to my virtual machines. This setup ensures credentials are not exposed and provides a reliable, auditable way to connect remotely for system administration tasks.

Key features include:
- **Multi-factor authentication (MFA)** for added security.
- **Access policies and role management** to enforce strict control.

Learn how to [host your own teleport server](diary/host-your-own-teleport-server).

<br>

- [**FOCZ - Fortress Server**](https://fortress.conanzhang.tech)

FOCZ - Fortress Server is a self-hosted VMWare *(by BroadCom)* vCentre Server, on top of my EXSI Type 1 Hypervisor.

VMWare *(by BroadCom)* vCentre server allows me to manage all of my VMs at ease.

Learn how to [host your own VMWare *(by BroadCom)* vCentre Server server](diary/host-your-own-vcentre-server) - This is a paid server subscription, not open-source.

- [**FOCZ - Compliance**](https://compliance.conanzhang.tech)

FOCZ - Compliance is a self-hosted Nessus server.

Nessus checks for common vulnerabilities (CVSS) in my environment and gives recommendations to patch them.

Learn how to [host your own Nessus server using Nessus Community Edition](diary/host-your-own-nessus-server-nessus-community-edition).


- [**FOCZ - ztcc.ink**](https://www.short.io)

FOCZ - ztcc.ink is a free SaaS solution Link Shortener using my ztcc.ink custom domain.

Learn how to [USE ShortIO](https://short.io/).


---

#### Backup
- **VEEAM Backup and Replication Server**
- **Azure Cloud**
---

### Future Improvements

NA for now