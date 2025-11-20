# Quick Diagnosis Script
# Run this to quickly diagnose build issues

Write-Host "=== Quick Build Diagnosis ===" -ForegroundColor Cyan
Write-Host ""

# 1. Check Git Submodules
Write-Host "1. Checking Git Submodules..." -ForegroundColor Yellow
if (Test-Path ".gitmodules") {
    Write-Host "   OK: .gitmodules file found" -ForegroundColor Green
    Write-Host "   Submodule status:" -ForegroundColor Gray
    $status = git submodule status 2>&1
    if ($LASTEXITCODE -eq 0) {
        $status | ForEach-Object {
            if ($_ -match '^-\s') {
                Write-Host "   ERROR: $_ (NOT INITIALIZED)" -ForegroundColor Red
            } elseif ($_ -match '^\+\s') {
                Write-Host "   WARNING: $_ (HAS UNCOMMITTED CHANGES)" -ForegroundColor Yellow
            } else {
                Write-Host "   OK: $_" -ForegroundColor Green
            }
        }
    }
} else {
    Write-Host "   INFO: No .gitmodules file found" -ForegroundColor Gray
    Write-Host "   Dependencies need to be added manually (see ADD_DEPENDENCIES.md)" -ForegroundColor Yellow
}

Write-Host ""

# 2. Check Key Dependencies
Write-Host "2. Checking Key Dependencies..." -ForegroundColor Yellow
$deps = @(
    @{Name="CrossRoads"; Paths=@("..\CrossRoads\GameServerLib\GameServerLib.vcxproj", "..\Cryptic\CrossRoads\GameServerLib\GameServerLib.vcxproj")},
    @{Name="Core"; Paths=@("..\Core", "..\Cryptic\Core", "..\core")},
    @{Name="libs"; Paths=@("..\libs", "libs")}
)

foreach ($dep in $deps) {
    $found = $false
    foreach ($path in $dep.Paths) {
        if (Test-Path $path) {
            Write-Host "   OK: $($dep.Name) found at: $path" -ForegroundColor Green
            $found = $true
            break
        }
    }
    if (-not $found) {
        Write-Host "   ERROR: $($dep.Name) NOT FOUND" -ForegroundColor Red
    }
}

Write-Host ""

# 3. Check Project References
Write-Host "3. Checking Project References..." -ForegroundColor Yellow
if (Test-Path "NNOGameServer.vcxproj") {
    $projContent = Get-Content "NNOGameServer.vcxproj" -Raw
    $refs = [regex]::Matches($projContent, '<ProjectReference\s+Include="([^"]+)"')
    Write-Host "   Found $($refs.Count) project references" -ForegroundColor Gray
    
    $missingRefs = 0
    foreach ($ref in $refs) {
        $path = $ref.Groups[1].Value -replace '/', '\'
        if (Test-Path $path) {
            Write-Host "   OK: $path" -ForegroundColor DarkGreen
        } else {
            Write-Host "   ERROR: $path (NOT FOUND)" -ForegroundColor Red
            $missingRefs++
        }
    }
    
    if ($missingRefs -gt 0) {
        Write-Host "   CRITICAL: $missingRefs project references are missing!" -ForegroundColor Red
        Write-Host "   This will cause MSBuild to skip compilation (silent failure)" -ForegroundColor Red
    }
} else {
    Write-Host "   ERROR: NNOGameServer.vcxproj not found" -ForegroundColor Red
}

Write-Host ""

# 4. Check Source Files
Write-Host "4. Checking Source Files..." -ForegroundColor Yellow
$sourceFiles = @(
    "NNOLogging.c",
    "Common\NNOCommon.c",
    "Common\NNOCommon.h"
)

foreach ($file in $sourceFiles) {
    if (Test-Path $file) {
        Write-Host "   OK: $file" -ForegroundColor Green
    } else {
        Write-Host "   WARNING: $file not found" -ForegroundColor Yellow
    }
}

Write-Host ""

# 5. Summary
Write-Host "=== Summary ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "If you see 'ERROR' or 'NOT FOUND' above:" -ForegroundColor Yellow
Write-Host "  1. If .gitmodules exists: Run 'git submodule update --init --recursive'" -ForegroundColor White
Write-Host "  2. If no .gitmodules: Follow ADD_DEPENDENCIES.md to add dependencies manually" -ForegroundColor White
Write-Host ""
Write-Host "For GitHub Actions:" -ForegroundColor Yellow
Write-Host "  Ensure checkout step has: submodules: recursive" -ForegroundColor White

