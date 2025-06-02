# PowerShell script to copy Qt and MinGW DLLs
# Run this after deploy_simple.bat

param(
    [string]$QtPath = "D:\Qt\6.9.0\mingw_64",
    [string]$MinGWPath = "D:\Qt\Tools\mingw1310_64",
    [string]$DeployDir = ".\ApoLoudness"
)

Write-Host "Qt DLL Deployment Script" -ForegroundColor Cyan
Write-Host "========================" -ForegroundColor Cyan
Write-Host ""

# Check if paths exist
if (-not (Test-Path $QtPath)) {
    Write-Host "ERROR: Qt path not found: $QtPath" -ForegroundColor Red
    Write-Host "Please specify correct Qt path with -QtPath parameter" -ForegroundColor Yellow
    exit 1
}

if (-not (Test-Path $MinGWPath)) {
    Write-Host "ERROR: MinGW path not found: $MinGWPath" -ForegroundColor Red
    Write-Host "Please specify correct MinGW path with -MinGWPath parameter" -ForegroundColor Yellow
    exit 1
}

if (-not (Test-Path $DeployDir)) {
    Write-Host "ERROR: Deployment directory not found: $DeployDir" -ForegroundColor Red
    Write-Host "Please run deploy_simple.bat first" -ForegroundColor Yellow
    exit 1
}

# Core Qt DLLs
$qtDlls = @(
    "Qt6Core.dll",
    "Qt6Gui.dll", 
    "Qt6Widgets.dll",
    "Qt6Multimedia.dll",
    "Qt6Network.dll"
)

Write-Host "Copying Qt DLLs..." -ForegroundColor Yellow
foreach ($dll in $qtDlls) {
    $source = Join-Path $QtPath "bin\$dll"
    $dest = Join-Path $DeployDir $dll
    
    if (Test-Path $source) {
        Copy-Item $source $dest -Force
        Write-Host "  ✓ $dll" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $dll (NOT FOUND)" -ForegroundColor Red
    }
}

# MinGW Runtime DLLs
$mingwDlls = @(
    "libgcc_s_seh-1.dll",
    "libstdc++-6.dll",
    "libwinpthread-1.dll"
)

Write-Host ""
Write-Host "Copying MinGW DLLs..." -ForegroundColor Yellow
foreach ($dll in $mingwDlls) {
    $source = Join-Path $MinGWPath "bin\$dll"
    $dest = Join-Path $DeployDir $dll
    
    if (Test-Path $source) {
        Copy-Item $source $dest -Force
        Write-Host "  ✓ $dll" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $dll (NOT FOUND)" -ForegroundColor Red
    }
}

# Qt Plugins
$plugins = @{
    "platforms" = @("qwindows.dll")
    "styles" = @("qwindowsvistastyle.dll")
    "imageformats" = @("qico.dll")
    "multimedia" = @("windowsmediaplugin.dll", "ffmpegmediaplugin.dll")
}

Write-Host ""
Write-Host "Copying Qt Plugins..." -ForegroundColor Yellow
foreach ($pluginDir in $plugins.Keys) {
    $targetDir = Join-Path $DeployDir $pluginDir
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    
    Write-Host "  $pluginDir/" -ForegroundColor Cyan
    foreach ($plugin in $plugins[$pluginDir]) {
        $source = Join-Path $QtPath "plugins\$pluginDir\$plugin"
        $dest = Join-Path $targetDir $plugin
        
        if (Test-Path $source) {
            Copy-Item $source $dest -Force
            Write-Host "    ✓ $plugin" -ForegroundColor Green
        } else {
            if ($plugin -eq "ffmpegmediaplugin.dll") {
                Write-Host "    - $plugin (optional, not found)" -ForegroundColor Yellow
            } else {
                Write-Host "    ✗ $plugin (NOT FOUND)" -ForegroundColor Red
            }
        }
    }
}

# Additional dependencies that might be needed
Write-Host ""
Write-Host "Checking for additional dependencies..." -ForegroundColor Yellow

# OpenSSL (might be needed by Qt Network)
$opensslDlls = @("libcrypto-1_1-x64.dll", "libssl-1_1-x64.dll")
foreach ($dll in $opensslDlls) {
    $source = Join-Path $QtPath "bin\$dll"
    if (Test-Path $source) {
        Copy-Item $source $DeployDir -Force
        Write-Host "  ✓ $dll (OpenSSL)" -ForegroundColor Green
    }
}

# ICU libraries (for internationalization)
$icuDlls = Get-ChildItem "$QtPath\bin" -Filter "icu*.dll" -ErrorAction SilentlyContinue
if ($icuDlls) {
    Write-Host "  Found ICU libraries (optional):" -ForegroundColor Yellow
    foreach ($dll in $icuDlls) {
        # Skip, as they're usually not needed for basic apps
        Write-Host "    - $($dll.Name) (skipped)" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "Deployment complete!" -ForegroundColor Green
Write-Host "Total size: $([Math]::Round((Get-ChildItem $DeployDir -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB, 2)) MB" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Test ApoLoudness.exe on this machine"
Write-Host "2. Copy the $DeployDir folder to a clean Windows system"
Write-Host "3. Test both executables for missing DLLs"
Write-Host "4. Run create_portable.bat to create ZIP package"