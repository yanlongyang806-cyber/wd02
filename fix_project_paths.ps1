# 修复项目文件中的路径
# 将 ..\CrossRoads\ 改为 CrossRoads\
# 将 ..\libs\ 改为 libs\
# 将 ..\Core\ 改为 Core\

$ErrorActionPreference = "Stop"

Write-Host "=== 修复项目文件路径 ===" -ForegroundColor Cyan
Write-Host ""

$projectFile = "NNOGameServer.vcxproj"
if (-not (Test-Path $projectFile)) {
    Write-Host "ERROR: 找不到项目文件: $projectFile" -ForegroundColor Red
    exit 1
}

Write-Host "读取项目文件: $projectFile" -ForegroundColor Gray
$content = Get-Content $projectFile -Raw -Encoding UTF8

# 备份原文件
$backupFile = "$projectFile.backup"
Copy-Item $projectFile $backupFile -Force
Write-Host "已创建备份: $backupFile" -ForegroundColor Gray

# 路径替换规则
$replacements = @(
    @{ Old = '\.\.\\CrossRoads\\'; New = 'CrossRoads\' }
    @{ Old = '\.\.\\CrossRoads/'; New = 'CrossRoads/' }
    @{ Old = '\.\./CrossRoads/'; New = 'CrossRoads/' }
    @{ Old = '\.\.\\libs\\'; New = 'libs\' }
    @{ Old = '\.\.\\libs/'; New = 'libs/' }
    @{ Old = '\.\./libs/'; New = 'libs/' }
    @{ Old = '\.\.\\core\\'; New = 'Core\' }
    @{ Old = '\.\.\\core/'; New = 'Core/' }
    @{ Old = '\.\./core/'; New = 'Core/' }
    @{ Old = '\.\.\\Core\\'; New = 'Core\' }
    @{ Old = '\.\.\\Core/'; New = 'Core/' }
    @{ Old = '\.\./Core/'; New = 'Core/' }
)

$modified = $false
$newContent = $content

foreach ($replacement in $replacements) {
    if ($newContent -match $replacement.Old) {
        $newContent = $newContent -replace $replacement.Old, $replacement.New
        $modified = $true
        Write-Host "替换: $($replacement.Old) -> $($replacement.New)" -ForegroundColor Yellow
    }
}

if ($modified) {
    # 保存修改后的文件
    [System.IO.File]::WriteAllText((Resolve-Path $projectFile), $newContent, [System.Text.Encoding]::UTF8)
    Write-Host ""
    Write-Host "OK: 项目文件已更新" -ForegroundColor Green
    Write-Host ""
    Write-Host "修改摘要:" -ForegroundColor Cyan
    Write-Host "  - 所有 ..\CrossRoads\ 路径已改为 CrossRoads\" -ForegroundColor Gray
    Write-Host "  - 所有 ..\libs\ 路径已改为 libs\" -ForegroundColor Gray
    Write-Host "  - 所有 ..\Core\ 路径已改为 Core\" -ForegroundColor Gray
    Write-Host ""
    Write-Host "下一步:" -ForegroundColor Cyan
    Write-Host "  1. 检查修改是否正确: git diff $projectFile" -ForegroundColor Yellow
    Write-Host "  2. 如果正确，提交: git add $projectFile" -ForegroundColor Yellow
    Write-Host "  3. 提交: git commit -m 'Fix project paths to use repository-internal dependencies'" -ForegroundColor Yellow
} else {
    Write-Host "INFO: 未发现需要修改的路径" -ForegroundColor Gray
    Write-Host "  项目文件可能已经使用正确的路径" -ForegroundColor Gray
}

Write-Host ""
Write-Host "备份文件: $backupFile" -ForegroundColor Gray
Write-Host "如需恢复，请运行: Copy-Item $backupFile $projectFile -Force" -ForegroundColor Gray

