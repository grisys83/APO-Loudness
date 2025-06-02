# PowerShell script to check and list all dependencies

param(
    [string]$ExePath = ".\ApoLoudness\ApoLoudness.exe"
)

Write-Host "ApoLoudness Dependency Checker" -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $ExePath)) {
    Write-Host "ERROR: Executable not found at $ExePath" -ForegroundColor Red
    exit 1
}

Write-Host "Checking dependencies for: $ExePath" -ForegroundColor Yellow
Write-Host ""

# Function to get DLL dependencies using dumpbin or Dependencies.exe
function Get-Dependencies {
    param([string]$FilePath)
    
    $dependencies = @()
    
    # Try using dumpbin (part of Visual Studio)
    $dumpbin = Get-Command dumpbin -ErrorAction SilentlyContinue
    if ($dumpbin) {
        $output = & dumpbin /dependents $FilePath 2>$null
        $inDependents = $false
        foreach ($line in $output) {
            if ($line -match "Image has the following dependencies:") {
                $inDependents = $true
                continue
            }
            if ($inDependents -and $line -match "^\s+(\S+\.dll)") {
                $dependencies += $matches[1]
            }
            if ($line -match "Summary") {
                break
            }
        }
    }
    
    return $dependencies | Sort-Object -Unique
}

# Get direct dependencies
$directDeps = Get-Dependencies $ExePath

Write-Host "Direct Dependencies:" -ForegroundColor Green
foreach ($dep in $directDeps) {
    $found = $false
    $locations = @(
        ".\ApoLoudness\$dep",
        "$env:WINDIR\System32\$dep",
        "$env:WINDIR\SysWOW64\$dep"
    )
    
    foreach ($loc in $locations) {
        if (Test-Path $loc) {
            $found = $true
            break
        }
    }
    
    if ($found) {
        Write-Host "  ✓ $dep" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $dep (MISSING)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Checking Qt plugins..." -ForegroundColor Yellow

$qtPlugins = @{
    "platforms" = @("qwindows.dll")
    "styles" = @("qwindowsvistastyle.dll")
    "imageformats" = @("qico.dll", "qsvg.dll")
    "multimedia" = @("windowsmediaplugin.dll", "ffmpegmediaplugin.dll")
}

foreach ($plugin in $qtPlugins.GetEnumerator()) {
    Write-Host "  $($plugin.Key):" -ForegroundColor Cyan
    foreach ($dll in $plugin.Value) {
        $path = ".\ApoLoudness\$($plugin.Key)\$dll"
        if (Test-Path $path) {
            Write-Host "    ✓ $dll" -ForegroundColor Green
        } else {
            Write-Host "    ✗ $dll (Optional)" -ForegroundColor Yellow
        }
    }
}

Write-Host ""
Write-Host "Deployment checklist:" -ForegroundColor Yellow
Write-Host "1. Run windeployqt.exe on both executables"
Write-Host "2. Copy MinGW runtime DLLs"
Write-Host "3. Test on a clean Windows installation"
Write-Host "4. Create installer or portable ZIP"
Write-Host ""