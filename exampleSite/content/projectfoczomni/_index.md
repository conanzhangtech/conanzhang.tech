---
title: "Project FOCZOmni: Home Lab Built with Passion"
description: "A personal playground for experimentation and innovation"
image: "images/author.jpg"
layout: "projectfoczomnilanding"
draft: false

---

> **A personal playground for experimentation and innovation.**

#### Overview
#ProjectFOCZOmni is my dedicated home lab environment, developed to simulate real-world infrastructure and test technologies. It enables me to explore, learn, and innovate by building a controlled environment for deploying and managing different systems. 

**The lab also serves as a testing ground me to do Proof-of-Concept before turning ideas into reality.**

The following is a high-level overview of my infrastructure:

---

## Hardware Setup
- **Server**:  
  - Brand/Model: [e.g., Dell PowerEdge, HP ProLiant, Custom Build]  
  - CPU: [e.g., Intel Xeon E5-2670]  
  - RAM: [e.g., 64GB DDR4]  
  - Storage: [e.g., 2TB SSD, 4TB HDD RAID 5]  

- **Network Devices**:  
  - Router: [e.g., Ubiquiti UniFi Dream Machine]  
  - Switch: [e.g., Netgear 16-Port Gigabit Switch]  
  - Access Points: [e.g., TP-Link Deco M5 Mesh Wi-Fi System]  

---

## Networking and Connectivity
- **Network Configuration**:  
  - IP Schema: 192.168.1.0/24  
  - VLANs:  
    - VLAN 10: Management  
    - VLAN 20: IoT Devices  
    - VLAN 30: Guests  

- **Firewall and NAT**:  
  - Firewall: pfSense or equivalent  
  - Port Forwarding: Enabled for specific services  

- **DNS and DHCP**:  
  - Local DNS: Pi-hole or AdGuard Home  
  - DHCP: Manage
