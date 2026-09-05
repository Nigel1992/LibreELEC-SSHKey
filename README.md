[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/Nigel1992)

# 🔑 LibreELEC SSH Key Setup Script

A PowerShell script to automate SSH key generation and setup for LibreELEC devices. This script streamlines the process of creating and deploying SSH keys, making it easier to establish secure connections to your LibreELEC media center.

## ✨ Features

- 🔐 Generates a secure 4096-bit RSA key pair
- 🔒 Optional SSH key passphrase for enhanced security
- 🚀 Automatically sets up the SSH agent
- 📤 Deploys the public key to your LibreELEC device
- 🛠️ Configures proper permissions on the remote device
- 💫 Handles cleanup of existing keys
- ⚙️ Customizable parameters for flexibility
- 🎨 Interactive color-coded output

## 📋 Prerequisites

- Windows 10/11 with PowerShell
- OpenSSH client installed
- Network access to your LibreELEC device
- LibreELEC device with SSH enabled

> **Note**: In the commands below, `$HOME` refers to your Windows user directory (typically `C:\Users\YourUsername`). For example, `$HOME\.ssh` would be `C:\Users\YourUsername\.ssh` on your system.

## 🚀 Quick Start

### Option 1: Direct PowerShell Download and Run
Run this command in PowerShell to download and execute the script:

```powershell
iex "& { $(irm 'https://raw.githubusercontent.com/Nigel1992/LibreELEC-SSHKey/main/setup-libreelec-ssh.ps1') }"
```

The script will interactively prompt you for:
1. Remote username (default: root)
2. LibreELEC IP address or hostname (default: libreelec)
3. SSH key path (default: $HOME\.ssh\libreelec)
4. Whether to set a passphrase (optional)

You can also provide these parameters directly:

```powershell
.\setup-libreelec-ssh.ps1 -RemoteUser "osmc" -RemoteHost "192.168.1.100" -sshKeyPath "$HOME\.ssh\media_center" -Passphrase "your_secure_passphrase"
```

### Option 2: Clone and Run
1. Clone this repository:
   ```powershell
   git clone https://github.com/Nigel1992/LibreELEC-SSHKey.git
   cd LibreELEC-SSHKey
   ```

2. Ensure you have execution permissions:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

3. Run the script:
   ```powershell
   .\setup-libreelec-ssh.ps1
   ```

## 💻 Usage

### Basic Usage

Run the script without parameters for an interactive setup:
```powershell
.\setup-libreelec-ssh.ps1
```

The script will:
1. Ask for configuration details (or use defaults)
2. Show a summary of the settings
3. Ask for confirmation before proceeding
4. Generate and deploy the SSH key
5. Display connection instructions

### Parameters

| Parameter | Default Value | Description |
|-----------|--------------|-------------|
| RemoteUser | root | Username on the LibreELEC device |
| RemoteHost | libreelec | Hostname or IP of the LibreELEC device |
| sshKeyPath | $HOME\.ssh\libreelec | Path where the SSH key will be generated |
| Passphrase | None | Optional passphrase to encrypt the SSH key |

## 🔒 Security Notes

- You can optionally set a passphrase for additional security
- If no passphrase is set, the key will be generated without one for automation purposes
- Make sure to protect your private key file
- The default key location is in your user's .ssh directory (`$HOME\.ssh`, which is `C:\Users\YourUsername\.ssh` on Windows)
- Always verify the script content before running it directly from the internet

## 💖 Support the Project

All donations go towards your chosen charity. You can pick any charity you'd like, and 5% is retained due to Ko-Fi fees. As a thank you, your name will be listed as a supporter/donor in a GitHub project. Feel free to email me at thedjskywalker@gmail.com for proof! :)

[![Ko-Fi](https://img.shields.io/badge/Ko--Fi-Support%20me-FF5E5B?style=for-the-badge&logo=ko-fi&logoColor=white)](https://ko-fi.com/nigel1992)
[![PayPal](https://img.shields.io/badge/PayPal-Donate-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://www.paypal.com/donate/?hosted_button_id=KYV9ARF99ZSCE)

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⭐ Support

If you find this script helpful, please give it a star on GitHub! 
