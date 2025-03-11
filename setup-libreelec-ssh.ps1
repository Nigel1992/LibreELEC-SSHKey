[CmdletBinding()]
param (
    [string]$RemoteUser = "root",
    [string]$RemoteHost = "libreelec",
    [string]$sshKeyPath = "$HOME\.ssh\libreelec",
    [string]$Passphrase = ""
)

# Function to write colored output
function Write-ColorOutput {
    param(
        [Parameter(Mandatory)]
        [string]$Message,
        
        [Parameter(Mandatory)]
        [string]$Color,

        [switch]$NoNewline
    )
    if ($NoNewline) {
        Write-Host $Message -ForegroundColor $Color -NoNewline
    } else {
        Write-Host $Message -ForegroundColor $Color
    }
}

# Function to ensure directory exists
function Ensure-Directory {
    param (
        [string]$Path
    )
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
        Write-ColorOutput "Created directory: $Path" "Gray"
    }
}

# Function to prompt for parameters if not provided from command line
function Get-UserInput {
    Write-ColorOutput "🔑 LibreELEC SSH Key Setup" "Cyan"
    Write-ColorOutput "=========================" "Cyan"
    
    Write-ColorOutput "`n👤 Enter remote username [default: $RemoteUser]: " "Yellow" -NoNewline
    $input = Read-Host
    if ($input) { $RemoteUser = $input }
    
    Write-ColorOutput "`n🌐 Enter LibreELEC IP address or hostname [default: $RemoteHost]: " "Yellow" -NoNewline
    $input = Read-Host
    if ($input) { $RemoteHost = $input }
    
    Write-ColorOutput "`n📂 Enter SSH key path [default: $sshKeyPath]: " "Yellow" -NoNewline
    $input = Read-Host
    if ($input) { $sshKeyPath = $input }

    Write-ColorOutput "`n🔒 Do you want to set a passphrase for the SSH key? (Y/N) [default: N]: " "Yellow" -NoNewline
    $usePassphrase = Read-Host
    if ($usePassphrase -and $usePassphrase.ToLower() -eq 'y') {
        Write-ColorOutput "`n   Enter passphrase (or press Enter for no passphrase): " "Yellow" -NoNewline
        $Passphrase = Read-Host
        if ($Passphrase) {
            Write-ColorOutput "   Confirm passphrase: " "Yellow" -NoNewline
            $confirmPass = Read-Host
            if ($Passphrase -ne $confirmPass) {
                Write-ColorOutput "`n❌ Passphrases do not match. Please try again." "Red"
                exit 1
            }
        }
    }

    # Return the values
    return @{
        RemoteUser = $RemoteUser
        RemoteHost = $RemoteHost
        sshKeyPath = $sshKeyPath
        Passphrase = $Passphrase
    }
}

# Get parameters if not provided from command line
$params = Get-UserInput

# Update script variables with either user input or defaults
$RemoteUser = $params.RemoteUser
$RemoteHost = $params.RemoteHost
$sshKeyPath = $params.sshKeyPath
$Passphrase = $params.Passphrase

# Show configuration
Write-ColorOutput "`n📋 Configuration:" "Magenta"
Write-ColorOutput "---------------" "Magenta"
Write-ColorOutput "Remote User: $RemoteUser" "White"
Write-ColorOutput "Remote Host: $RemoteHost" "White"
Write-ColorOutput "SSH Key Path: $sshKeyPath" "White"
Write-ColorOutput "Passphrase: " "White" -NoNewline
Write-ColorOutput $(if ($Passphrase) { "Set" } else { "None" }) $(if ($Passphrase) { "Green" } else { "Yellow" })

# Confirm with user
Write-ColorOutput "`n❓ Do you want to proceed with these settings? (Y/N) [default: Y]: " "Yellow" -NoNewline
$confirm = Read-Host
if ($confirm -and $confirm.ToLower() -eq 'n') {
    Write-ColorOutput "`n❌ Setup cancelled by user" "Red"
    exit
}

Write-ColorOutput "`n🚀 Starting SSH key setup..." "Green"

# Ensure .ssh directory exists
$sshDir = Split-Path -Parent $sshKeyPath
Ensure-Directory $sshDir

# Generate a new SSH key with or without passphrase
Write-ColorOutput "🔑 Generating new SSH key..." "Blue"
try {
    ssh-keygen -t rsa -b 4096 -f $sshKeyPath -N $Passphrase
} catch {
    Write-ColorOutput "`n❌ Failed to generate SSH key" "Red"
    Write-ColorOutput "Error details: $_" "Red"
    exit 1
}

# Start the SSH agent
Write-ColorOutput "🔄 Starting SSH agent..." "Blue"
try {
    Start-Service ssh-agent -ErrorAction Stop
} catch {
    Write-ColorOutput "`n⚠️ Warning: Could not start SSH agent. You may need to add the key manually later." "Yellow"
}

# Add the new key to the SSH agent
Write-ColorOutput "➕ Adding key to SSH agent..." "Blue"
if ($Passphrase) {
    Write-ColorOutput "   (You'll need to enter your passphrase)" "Yellow"
}
try {
    ssh-add $sshKeyPath
} catch {
    Write-ColorOutput "`n⚠️ Warning: Could not add key to SSH agent. You may need to add it manually later." "Yellow"
}

# Verify key files exist
if (-not (Test-Path "$sshKeyPath.pub")) {
    Write-ColorOutput "`n❌ Public key file not found. Key generation may have failed." "Red"
    exit 1
}

# Read the public key content
Write-ColorOutput "📤 Deploying public key to LibreELEC..." "Blue"
try {
    $publicKey = Get-Content "$sshKeyPath.pub"

    # Copy the public key to the remote device
    ssh $RemoteUser@$RemoteHost "mkdir -p /storage/.ssh && echo '$publicKey' >> /storage/.ssh/authorized_keys && chmod 600 /storage/.ssh/authorized_keys && systemctl restart sshd"
    
    # Output success message
    Write-ColorOutput "`n✅ SSH key setup completed successfully!" "Green"
    Write-ColorOutput "📝 Connection details:" "Cyan"
    Write-ColorOutput "   ssh -i $sshKeyPath $RemoteUser@$RemoteHost" "White"
    if ($Passphrase) {
        Write-ColorOutput "`n⚠️ Note: You'll need to enter your passphrase when using this key" "Yellow"
    }
} catch {
    Write-ColorOutput "`n❌ Error: Failed to deploy SSH key to remote device" "Red"
    Write-ColorOutput "Error details: $_" "Red"
    Write-ColorOutput "`nTroubleshooting tips:" "Yellow"
    Write-ColorOutput "1. Make sure LibreELEC is running and accessible at '$RemoteHost'" "Yellow"
    Write-ColorOutput "2. Verify you can connect via SSH: ssh $RemoteUser@$RemoteHost" "Yellow"
    Write-ColorOutput "3. Check if the username '$RemoteUser' exists on LibreELEC" "Yellow"
    exit 1
}