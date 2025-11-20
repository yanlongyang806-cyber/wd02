# 如何查看构建日志

## 📥 下载构建日志

构建日志已上传为 artifact，可以通过以下方式查看：

### 方法 1: 从 GitHub Actions 页面下载

1. 访问：https://github.com/yanlongyang806-cyber/wd02/actions
2. 点击最新的工作流运行
3. 滚动到底部，找到 "Artifacts" 部分
4. 点击 `build-log` artifact
5. 下载 `build-log.zip`
6. 解压后查看 `build.log` 文件

### 方法 2: 直接访问下载链接

如果工作流提供了下载链接，可以直接访问：
```
https://github.com/yanlongyang806-cyber/wd02/actions/runs/[RUN_ID]/artifacts/[ARTIFACT_ID]
```

## 🔍 分析构建日志

### 关键错误模式

在 `build.log` 中搜索以下关键字：

#### 1. 项目引用错误
```
error MSB3202: The project file "...\CrossRoads\GameServerLib\GameServerLib.vcxproj" was not found.
```
**含义**：项目引用的文件不存在

#### 2. 属性表错误
```
error MSB4019: The imported project "...\PropertySheets\GeneralSettings.props" was not found.
```
**含义**：PropertySheets 文件不存在或路径错误

#### 3. 头文件错误
```
fatal error C1083: Cannot open include file: 'xxx.h': No such file or directory
```
**含义**：找不到头文件，通常是依赖缺失

#### 4. 链接错误
```
error LNK2019: unresolved external symbol "xxx" referenced in function "yyy"
```
**含义**：找不到库文件或函数定义

#### 5. Pre-build 事件错误
```
error MSB3073: The command "...\structparser.exe" exited with code 9009.
```
**含义**：预构建命令失败

### 快速搜索命令

在 PowerShell 中：

```powershell
# 搜索所有错误
Select-String -Path "build.log" -Pattern "error" -CaseSensitive:$false

# 搜索项目引用错误
Select-String -Path "build.log" -Pattern "MSB3202" -CaseSensitive:$false

# 搜索头文件错误
Select-String -Path "build.log" -Pattern "C1083" -CaseSensitive:$false

# 查看最后 50 行
Get-Content "build.log" -Tail 50
```

## 📊 工作流改进

新的工作流现在会自动：

1. ✅ **提取关键错误**：
   - MSB3202 (项目文件未找到)
   - MSB4019 (导入项目未找到)
   - C1083 (无法打开头文件)
   - LNK2019 (未解析的外部符号)

2. ✅ **显示最后 30 行**：
   - 带颜色高亮（错误=红色，警告=黄色，成功=绿色）

3. ✅ **分析构建活动**：
   - 是否有编译活动
   - 是否有链接活动
   - 跳过的任务

## 💡 常见问题

### Q: 日志文件太大，如何快速找到错误？

A: 使用搜索功能：
```powershell
# 只显示包含 "error" 的行
Select-String -Path "build.log" -Pattern "error" -CaseSensitive:$false | Select-Object -First 20
```

### Q: 如何查看特定类型的错误？

A: 使用特定错误代码：
```powershell
# MSB3202: 项目文件未找到
Select-String -Path "build.log" -Pattern "MSB3202"

# C1083: 头文件未找到
Select-String -Path "build.log" -Pattern "C1083"
```

### Q: 构建日志显示成功，但没有输出文件？

A: 检查是否有编译活动：
```powershell
Select-String -Path "build.log" -Pattern "Compiling|Linking" -CaseSensitive:$false
```

如果没有，说明构建在准备阶段就失败了（静默失败）。

## 📝 下一步

1. **下载构建日志**：从 GitHub Actions 页面下载
2. **分析关键错误**：搜索上述错误模式
3. **根据错误修复**：
   - 项目引用错误 → 添加依赖或修复路径
   - 头文件错误 → 添加依赖
   - 链接错误 → 添加库文件

## 🔗 相关文档

- `SILENT_FAILURE_DIAGNOSIS.md` - 静默失败诊断
- `ROOT_CAUSE_ANALYSIS.md` - 根本原因分析
- `DIAGNOSIS_AND_FIX.md` - 诊断与修复指南

