[CmdletBinding()]
param (
    [string]$RemoteUser = "root",           # Default remote user
    [string]$RemoteHost = "libreelec",      # Default remote host (or IP)
    [string]$sshKeyPath = "$HOME\.ssh\libreelec"   # Custom key path
)

# Remove any existing SSH key
Remove-Item "$sshKeyPath*" -Force -ErrorAction SilentlyContinue

# Generate a new SSH key without a passphrase
ssh-keygen -t rsa -b 4096 -f $sshKeyPath -N ""

# Start the SSH agent
Start-Service ssh-agent -ErrorAction SilentlyContinue

# Add the new key to the SSH agent
ssh-add $sshKeyPath

# Read the public key content
$publicKey = Get-Content "$sshKeyPath.pub"

# Copy the public key to the remote device
ssh $RemoteUser@$RemoteHost "mkdir -p /storage/.ssh && echo '$publicKey' >> /storage/.ssh/authorized_keys && chmod 600 /storage/.ssh/authorized_keys && systemctl restart sshd"

# Output success message
Write-Output "SSH key successfully copied to $RemoteUser@$RemoteHost."
Write-Output "Connect using: ssh -i $sshKeyPath $RemoteUser@$RemoteHost" 