![PowerShell](https://img.shields.io/badge/PowerShell-Tool-blue)
![License](https://img.shields.io/github/license/pryrotech/bulk-ad-entra-sandbox-loader)
![Maintained](https://img.shields.io/badge/Maintained-Yes-brightgreen)
[![GitHub all releases](https://img.shields.io/github/downloads/pryrotech/bulk-ad-entra-sandbox-loader/total.svg?cacheSeconds=3600)](https://github.com/pryrotech/bulk-ad-entra-sandbox-loader/releases)

![BAESL Banner](https://github.com/pryrotech/bulk-ad-entra-sandbox-loader/blob/main/BAESL.png)

# Bulk AD and Entra Sandbox Loader (BAESL)

**BAESL** is a PowerShell-based utility designed for developers and administrators to rapidly populate test environments with realistic identity data. Whether you're working with on-prem Active Directory or Microsoft Entra, BAESL helps simulate real-world usage by:

- Creating bulk user accounts with customizable attributes  
- Automating user actions to mimic authentic behavior  
- Supporting sandboxed environments for safe, repeatable testing  

Ideal for development, demos, and compliance testing, BAESL streamlines identity provisioning so you can focus on what matters: building and validating secure systems.

---

## 🚀 Features

### 🧑‍💻 Identity Provisioning

- **Custom Attribute Injection**  
  Define user attributes like department, job title, into a config file for automated bulk sandbox user creation.

- **Group Assignment**  
  Assign users to security groups or Microsoft 365 groups.

- **Role Simulation**  
  Assign Entra roles (e.g., Global Reader, Helpdesk Admin) for RBAC testing.

---
# 🚀 Getting Started

The instructions below will allow you to install and load BAESL for usage. 

## 📦 Prerequisites
- Windows 10/11 or Windows Server  
- PowerShell 7+  
- Permissions to create and modify directory objects in your target environment

## 📥 Installation

```powershell
git clone https://github.com/pryrotech/bulk-ad-entra-sandbox-loader.git
cd bulk-ad-entra-sandbox-loader 
```
## 🚀 Run BAESL
```powershell
./baesl-main.ps1
```
---
# 🤝 Contributing
Contributions are welcome — whether you’re fixing bugs, adding features, or improving documentation.

# 🧩 How to Contribute
- Fork the repository
- Create a feature branch
- Make the changes you desire
- Submit a Pull Request with a description of the change and any relevant information.

---
# 🐛 Reporting Issues
If you encounter issues or want to request a feature, please raise an issue with reproduction steps or other relevant information.
