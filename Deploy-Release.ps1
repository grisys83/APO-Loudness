# PowerShell deployment script for ApoLoudness
# Usage: .\Deploy-Release.ps1 [-Version "0.3.3"] [-QtPath "C:\Qt\6.9.0\mingw_64"] [-SkipBuild]

param(
    [string]$Version = "0.3.3",
    [string]$QtPath = "C:\Qt\6.9.0\mingw_64",
    [switch]$SkipBuild,
    [switch]$SkipFilters,
    [switch]$Debug
)

$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "ApoLoudness v$Version Deployment Script" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# Paths
$ProjectRoot = $PSScriptRoot
$BuildDir = Join-Path $ProjectRoot "build-release-ps"
$DeployDir = Join-Path $ProjectRoot "deployment"
$ApoLoudnessDir = Join-Path $DeployDir "ApoLoudness"
$FiltersDir = Join-Path $DeployDir "filters"

# Qt tools
$QMake = Join-Path $QtPath "bin\qmake.exe"
$WinDeployQt = Join-Path $QtPath "bin\windeployqt.exe"
$MinGWMake = "mingw32-make"

# Verify Qt installation
if (-not (Test-Path $QMake)) {
    Write-Error "Qt not found at $QtPath. Please install Qt or specify correct path with -QtPath parameter."
    exit 1
}

# Clean previous deployment
if (Test-Path $ApoLoudnessDir) {
    Write-Host "Cleaning previous deployment..." -ForegroundColor Yellow
    Remove-Item $ApoLoudnessDir -Recurse -Force
}

# Create directories
Write-Host "Creating deployment directories..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path $ApoLoudnessDir | Out-Null
New-Item -ItemType Directory -Force -Path "$ApoLoudnessDir\platforms" | Out-Null
New-Item -ItemType Directory -Force -Path "$ApoLoudnessDir\imageformats" | Out-Null
New-Item -ItemType Directory -Force -Path "$ApoLoudnessDir\multimedia" | Out-Null
New-Item -ItemType Directory -Force -Path "$FiltersDir\44100" | Out-Null
New-Item -ItemType Directory -Force -Path "$FiltersDir\48000" | Out-Null

# Build projects
if (-not $SkipBuild) {
    Write-Host "`nBuilding projects..." -ForegroundColor Yellow
    
    if (Test-Path $BuildDir) {
        Remove-Item $BuildDir -Recurse -Force
    }
    New-Item -ItemType Directory -Force -Path $BuildDir | Out-Null
    
    # Build ApoLoudness
    Write-Host "Building ApoLoudness.exe..." -ForegroundColor Green
    Push-Location $BuildDir
    & $QMake "$ProjectRoot\ApoLoudness.pro" -spec win32-g++ "CONFIG+=release"
    & $MinGWMake
    Pop-Location
    
    # Build ApoLoudnessCalibration
    Write-Host "Building ApoLoudnessCalibration.exe..." -ForegroundColor Green
    Push-Location $BuildDir
    & $QMake "$ProjectRoot\ApoLoudnessCalibration.pro" -spec win32-g++ "CONFIG+=release"
    & $MinGWMake clean
    & $MinGWMake
    Pop-Location
} else {
    Write-Host "Skipping build (using existing binaries)..." -ForegroundColor Yellow
}

# Copy executables
Write-Host "`nCopying executables..." -ForegroundColor Yellow
$ReleasePath = Join-Path $BuildDir "release"
if (-not (Test-Path $ReleasePath)) {
    # Try alternative build directory structure
    $ReleasePath = Join-Path $ProjectRoot "build\Desktop_Qt_6_9_0_MinGW_64_bit-Release\release"
}

Copy-Item (Join-Path $ReleasePath "ApoLoudness.exe") $ApoLoudnessDir -Force
Copy-Item (Join-Path $ReleasePath "ApoLoudnessCalibration.exe") $ApoLoudnessDir -Force

# Copy calibration.ini
$CalibrationFile = Join-Path $ProjectRoot "calibration.ini"
if (Test-Path $CalibrationFile) {
    Copy-Item $CalibrationFile $ApoLoudnessDir -Force
} else {
    Write-Host "Creating default calibration.ini..." -ForegroundColor Yellow
    @"
[General]
DeviceType=headphones
LastCalibration=

[CustomMeasurements]
40.0=59.3
50.0=65.4
60.0=71.8
70.0=77.7
80.0=83.0
"@ | Out-File -FilePath (Join-Path $ApoLoudnessDir "calibration.ini") -Encoding UTF8
}

# Deploy Qt dependencies
Write-Host "`nDeploying Qt dependencies..." -ForegroundColor Yellow
$WinDeployArgs = @(
    "--release",
    "--no-translations",
    "--no-system-d3d-compiler",
    "--no-opengl-sw",
    "--no-angle",
    "--no-webkit2",
    "--no-quick-import",
    "--no-virtualkeyboard"
)

& $WinDeployQt $WinDeployArgs (Join-Path $ApoLoudnessDir "ApoLoudness.exe")
& $WinDeployQt $WinDeployArgs (Join-Path $ApoLoudnessDir "ApoLoudnessCalibration.exe")

# Create README
Write-Host "Creating README..." -ForegroundColor Yellow
@"
ApoLoudness v$Version
====================

Equal-loudness volume control for EqualizerAPO

Installation:
1. Install EqualizerAPO first (https://equalizerapo.com)
2. Run this installer
3. Launch ApoLoudnessCalibration.exe to calibrate
4. Run ApoLoudness.exe for volume control

For detailed instructions:
https://github.com/grisys83/APO-Loudness

Changes in v$Version:
- Fixed Convolution path to use ../Filters/
- Real SPL calculation improvements
- Auto Offset mode enhancements
- Mouse control improvements
- Debug console removed
- English translations
- Calibration backup functionality
"@ | Out-File -FilePath (Join-Path $ApoLoudnessDir "README.txt") -Encoding UTF8

# Handle filter files
if (-not $SkipFilters) {
    Write-Host "`nChecking for filter files..." -ForegroundColor Yellow
    
    $Filters44k = Join-Path $ProjectRoot "Filters\44100"
    $Filters48k = Join-Path $ProjectRoot "Filters\48000"
    
    if ((Test-Path $Filters44k) -and (Get-ChildItem "$Filters44k\*.wav").Count -gt 0) {
        Write-Host "Copying 44.1kHz filters..." -ForegroundColor Green
        Copy-Item "$Filters44k\*.wav" "$FiltersDir\44100\" -Force
    } else {
        Write-Warning "No 44.1kHz filter files found! Run bulk_fir_filter_generator.py first."
    }
    
    if ((Test-Path $Filters48k) -and (Get-ChildItem "$Filters48k\*.wav").Count -gt 0) {
        Write-Host "Copying 48kHz filters..." -ForegroundColor Green
        Copy-Item "$Filters48k\*.wav" "$FiltersDir\48000\" -Force
    } else {
        Write-Warning "No 48kHz filter files found! Run bulk_fir_filter_generator.py first."
    }
}

# Summary
Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "Deployment Complete!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Files prepared in: $ApoLoudnessDir" -ForegroundColor Yellow
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Test executables in $ApoLoudnessDir"
Write-Host "2. Run Inno Setup with deployment\ApoLoudness_v033.iss"
Write-Host "3. Installer will be created as:"
Write-Host "   deployment\ApoLoudness_v${Version}_Setup.exe" -ForegroundColor Green
Write-Host ""

# Optional: Launch Inno Setup
$InnoSetup = "C:\Program Files (x86)\Inno Setup 6\Compil32.exe"
if (Test-Path $InnoSetup) {
    $response = Read-Host "Launch Inno Setup now? (Y/N)"
    if ($response -eq 'Y') {
        Start-Process $InnoSetup -ArgumentList "/cc", "`"$DeployDir\ApoLoudness_v033.iss`""
    }
}