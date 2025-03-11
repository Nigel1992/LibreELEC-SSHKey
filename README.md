# 🔑 LibreELEC SSH Key Setup Script

A PowerShell script to automate SSH key generation and setup for LibreELEC devices. This script streamlines the process of creating and deploying SSH keys, making it easier to establish secure connections to your LibreELEC media center.

## ✨ Features

- 🔐 Generates a secure 4096-bit RSA key pair
- 🚀 Automatically sets up the SSH agent
- 📤 Deploys the public key to your LibreELEC device
- 🛠️ Configures proper permissions on the remote device
- 💫 Handles cleanup of existing keys
- ⚙️ Customizable parameters for flexibility

## 📋 Prerequisites

- Windows 10/11 with PowerShell
- OpenSSH client installed
- Network access to your LibreELEC device
- LibreELEC device with SSH enabled

## 🚀 Quick Start

### Option 1: Direct PowerShell Download and Run
Run these commands in PowerShell to download and execute the script:

```powershell
# With default settings
irm https://raw.githubusercontent.com/Nigel1992/LibreELEC-SSHKey/main/setup-libreelec-ssh.ps1 | iex

# With custom parameters
(irm https://raw.githubusercontent.com/Nigel1992/LibreELEC-SSHKey/main/setup-libreelec-ssh.ps1) -RemoteUser "custom_user" -RemoteHost "192.168.1.100" -sshKeyPath "$HOME\.ssh\custom_key"
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

Run the script with default parameters:
```powershell
.\setup-libreelec-ssh.ps1
```

This will:
- Generate a new SSH key at `C:\Users\YourUsername\.ssh\libreelec`
- Connect to LibreELEC at hostname `libreelec`
- Use `root` as the default user

### Advanced Usage

Customize the parameters as needed:
```powershell
# With custom parameters
(irm https://raw.githubusercontent.com/Nigel1992/LibreELEC-SSHKey/main/setup-libreelec-ssh.ps1) -RemoteUser "custom_user" -RemoteHost "192.168.1.100" -sshKeyPath "C:\Users\YourUsername\.ssh\custom_key"

# Or if cloned locally
.\setup-libreelec-ssh.ps1 -RemoteUser "custom_user" -RemoteHost "192.168.1.100" -sshKeyPath "C:\Users\YourUsername\.ssh\custom_key"
```

### Parameters

| Parameter | Default Value | Description |
|-----------|--------------|-------------|
| RemoteUser | root | Username on the LibreELEC device |
| RemoteHost | libreelec | Hostname or IP of the LibreELEC device |
| sshKeyPath | C:\Users\YourUsername\.ssh\libreelec | Path where the SSH key will be generated |

## 🔒 Security Notes

- The script generates keys without a passphrase for automation purposes
- Make sure to protect your private key file
- Consider using a passphrase if security is a concern
- The default key location is in your Windows user's .ssh directory (C:\Users\YourUsername\.ssh)
- Always verify the script content before running it directly from the internet

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⭐ Support

If you find this script helpful, please give it a star on GitHub! 