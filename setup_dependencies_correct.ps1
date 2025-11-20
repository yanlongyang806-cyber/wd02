# 正确的依赖设置脚本
# 将依赖复制到仓库内（而不是引用外部路径）

param(
    [switch]$DryRun = $false
)

$ErrorActionPreference = "Stop"

Write-Host "=== 正确的依赖设置 ===" -ForegroundColor Cyan
Write-Host ""

# 检查是否在正确的目录
if (-not (Test-Path "NNOGameServer.vcxproj")) {
    Write-Host "ERROR: 请在 wd02 仓库根目录运行此脚本" -ForegroundColor Red
    exit 1
}

Write-Host "当前目录: $(Get-Location)" -ForegroundColor Gray
Write-Host ""

# 定义依赖源路径和目标路径
$dependencies = @(
    @{
        Name = "CrossRoads"
        Source = "..\Cryptic\CrossRoads"
        Target = "CrossRoads"
    },
    @{
        Name = "Core"
        Source = "..\Cryptic\Core"
        Target = "Core"
    },
    @{
        Name = "libs"
        Source = "..\libs"
        Target = "libs"
    }
)

$missingSources = @()
$readyToCopy = @()

# 检查源路径是否存在
Write-Host "=== 检查依赖源 ===" -ForegroundColor Cyan
foreach ($dep in $dependencies) {
    if (Test-Path $dep.Source) {
        Write-Host "OK: $($dep.Name) 源路径存在: $($dep.Source)" -ForegroundColor Green
        $readyToCopy += $dep
    } else {
        Write-Host "ERROR: $($dep.Name) 源路径不存在: $($dep.Source)" -ForegroundColor Red
        $missingSources += $dep
    }
}

if ($missingSources.Count -gt 0) {
    Write-Host ""
    Write-Host "ERROR: 以下依赖的源路径不存在:" -ForegroundColor Red
    $missingSources | ForEach-Object { Write-Host "  - $($_.Name): $($_.Source)" -ForegroundColor Red }
    Write-Host ""
    Write-Host "请确保依赖位于以下位置:" -ForegroundColor Yellow
    Write-Host "  - I:\wd1\Cryptic\CrossRoads" -ForegroundColor Gray
    Write-Host "  - I:\wd1\Cryptic\Core" -ForegroundColor Gray
    Write-Host "  - I:\wd1\libs" -ForegroundColor Gray
    exit 1
}

Write-Host ""
Write-Host "=== 检查目标路径 ===" -ForegroundColor Cyan
$existingTargets = @()
foreach ($dep in $readyToCopy) {
    if (Test-Path $dep.Target) {
        Write-Host "WARNING: $($dep.Name) 目标路径已存在: $($dep.Target)" -ForegroundColor Yellow
        Write-Host "  将跳过此依赖（如需更新，请手动删除后重新运行）" -ForegroundColor Gray
        $existingTargets += $dep
    } else {
        Write-Host "OK: $($dep.Name) 目标路径可用: $($dep.Target)" -ForegroundColor Green
    }
}

$toCopy = $readyToCopy | Where-Object { $_.Name -notin ($existingTargets | Select-Object -ExpandProperty Name) }

if ($toCopy.Count -eq 0) {
    Write-Host ""
    Write-Host "所有依赖已存在于仓库内，无需复制。" -ForegroundColor Green
    Write-Host ""
    Write-Host "下一步：修改项目文件路径" -ForegroundColor Cyan
    Write-Host "  运行: .\fix_project_paths.ps1" -ForegroundColor Yellow
    exit 0
}

Write-Host ""
if ($DryRun) {
    Write-Host "=== 模拟运行（不会实际复制） ===" -ForegroundColor Yellow
    foreach ($dep in $toCopy) {
        Write-Host "将复制: $($dep.Source) -> $($dep.Target)" -ForegroundColor Gray
    }
    Write-Host ""
    Write-Host "要实际执行，请运行: .\setup_dependencies_correct.ps1" -ForegroundColor Yellow
    exit 0
}

Write-Host "=== 开始复制依赖 ===" -ForegroundColor Cyan
Write-Host ""

foreach ($dep in $toCopy) {
    Write-Host "复制 $($dep.Name)..." -ForegroundColor Yellow
    Write-Host "  从: $($dep.Source)" -ForegroundColor Gray
    Write-Host "  到: $($dep.Target)" -ForegroundColor Gray
    
    try {
        Copy-Item -Path $dep.Source -Destination $dep.Target -Recurse -Force
        Write-Host "  OK: $($dep.Name) 复制完成" -ForegroundColor Green
    } catch {
        Write-Host "  ERROR: 复制失败: $_" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "=== 复制完成 ===" -ForegroundColor Green
Write-Host ""
Write-Host "下一步操作:" -ForegroundColor Cyan
Write-Host "  1. 修改项目文件路径（从 ..\ 改为仓库内路径）" -ForegroundColor Yellow
Write-Host "  2. 运行: .\fix_project_paths.ps1" -ForegroundColor Yellow
Write-Host "  3. 添加依赖到 Git: git add CrossRoads Core libs" -ForegroundColor Yellow
Write-Host "  4. 提交: git commit -m 'Add dependencies to repository'" -ForegroundColor Yellow

