# 正确的依赖设置方法

## ❌ 错误做法

**不能使用 `git add ../Cryptic/CrossRoads`**

Git 不允许跟踪仓库根目录之外的文件或目录。

```
fatal: ../Cryptic/CrossRoads: '../Cryptic/CrossRoads' is outside repository at 'I:/wd1/wd02'
```

## ✅ 正确做法

### 方法 1: 使用 Git Submodules（如果依赖是 Git 仓库）

如果 CrossRoads 和 Core 是独立的 Git 仓库：

```bash
cd I:/wd1/wd02

# 添加 CrossRoads 作为子模块
git submodule add <CrossRoads-Git-URL> CrossRoads

# 添加 Core 作为子模块
git submodule add <Core-Git-URL> Core

# 如果 libs 也是 Git 仓库
git submodule add <libs-Git-URL> libs

# 提交
git add .gitmodules CrossRoads Core libs
git commit -m "Add dependencies as submodules"
git push
```

**然后修改项目文件中的路径**：
- 从 `..\CrossRoads\` 改为 `.\CrossRoads\` 或 `CrossRoads\`
- 从 `..\Core\` 改为 `.\Core\` 或 `Core\`
- 从 `..\libs\` 改为 `.\libs\` 或 `libs\`

### 方法 2: 复制依赖到仓库内（如果依赖不是 Git 仓库）

如果 CrossRoads 和 Core 不是 Git 仓库，需要复制到仓库内：

```bash
cd I:/wd1/wd02

# 复制依赖到仓库内
Copy-Item -Path "..\Cryptic\CrossRoads" -Destination "CrossRoads" -Recurse
Copy-Item -Path "..\Cryptic\Core" -Destination "Core" -Recurse
Copy-Item -Path "..\libs" -Destination "libs" -Recurse

# 添加到 Git
git add CrossRoads Core libs
git commit -m "Add dependencies"
git push
```

**然后修改项目文件中的路径**：
- 从 `..\CrossRoads\` 改为 `.\CrossRoads\` 或 `CrossRoads\`
- 从 `..\Core\` 改为 `.\Core\` 或 `Core\`
- 从 `..\libs\` 改为 `.\libs\` 或 `libs\`

### 方法 3: 使用符号链接（仅本地，不适用于 GitHub）

**注意**：符号链接不能提交到 Git，只适用于本地开发。

```bash
# 以管理员身份运行
cd I:/wd1/wd02
New-Item -ItemType SymbolicLink -Path "CrossRoads" -Target "..\Cryptic\CrossRoads"
New-Item -ItemType SymbolicLink -Path "Core" -Target "..\Cryptic\Core"
New-Item -ItemType SymbolicLink -Path "libs" -Target "..\libs"
```

## 🔍 检查依赖是否为 Git 仓库

```bash
# 检查 CrossRoads
Test-Path "..\Cryptic\CrossRoads\.git"

# 检查 Core
Test-Path "..\Cryptic\Core\.git"

# 检查 libs
Test-Path "..\libs\.git"
```

如果返回 `True`，说明是 Git 仓库，应该使用方法 1（子模块）。
如果返回 `False`，说明不是 Git 仓库，应该使用方法 2（复制）。

## 📝 修改项目文件路径

无论使用哪种方法，都需要修改项目文件中的路径：

### 当前路径（错误）
```xml
<ProjectReference Include="..\CrossRoads\GameServerLib\GameServerLib.vcxproj">
<AdditionalIncludeDirectories>../CrossRoads/Common/Combat;...</AdditionalIncludeDirectories>
```

### 正确路径（依赖在仓库内）
```xml
<ProjectReference Include="CrossRoads\GameServerLib\GameServerLib.vcxproj">
<AdditionalIncludeDirectories>CrossRoads/Common/Combat;...</AdditionalIncludeDirectories>
```

或者使用相对路径：
```xml
<ProjectReference Include=".\CrossRoads\GameServerLib\GameServerLib.vcxproj">
<AdditionalIncludeDirectories>./CrossRoads/Common/Combat;...</AdditionalIncludeDirectories>
```

## 🎯 推荐方案

### 如果依赖是 Git 仓库（推荐）

1. 使用 Git Submodules
2. 修改项目文件路径为仓库内路径
3. 提交 `.gitmodules` 和子模块引用

### 如果依赖不是 Git 仓库

1. 复制依赖到仓库内
2. 使用 Git LFS 处理大文件（如果需要）
3. 修改项目文件路径为仓库内路径
4. 提交依赖文件

## ⚠️ 重要提示

- **Git 不能跟踪仓库外的文件**
- **依赖必须位于仓库根目录内**
- **项目文件中的路径必须匹配依赖的实际位置**

## 🔗 相关文档

- `ADD_DEPENDENCIES.md` - 如何添加依赖（需要更新）
- `GIT_SUBMODULES_GUIDE.md` - Git 子模块使用指南

