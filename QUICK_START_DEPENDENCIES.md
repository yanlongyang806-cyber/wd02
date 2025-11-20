# 快速开始：添加依赖

## 🎯 问题

**Git 不能跟踪仓库外的文件！**

不能使用 `git add ../Cryptic/CrossRoads`，因为 Git 不允许跟踪仓库根目录之外的文件。

## ✅ 解决方案（3 步）

### 步骤 1: 复制依赖到仓库内

```powershell
cd I:\wd1\wd02
.\setup_dependencies_correct.ps1
```

这会自动将依赖从 `..\Cryptic\CrossRoads` 复制到 `CrossRoads`（仓库内）。

### 步骤 2: 修复项目文件路径

```powershell
.\fix_project_paths.ps1
```

这会将项目文件中的所有 `..\CrossRoads\` 改为 `CrossRoads\`。

### 步骤 3: 提交到 Git

```powershell
git add CrossRoads Core libs NNOGameServer.vcxproj
git commit -m "Add dependencies to repository"
git push
```

## ✅ 完成！

现在依赖已经在仓库内，GitHub Actions 构建应该能够找到所有依赖。

## 🔍 验证

运行快速诊断：

```powershell
.\quick_diagnosis.ps1
```

应该显示：
- ✅ CrossRoads found
- ✅ Core found
- ✅ libs found
- ✅ All project references found

## 📝 详细说明

查看以下文档了解更多：
- `CORRECT_DEPENDENCY_SETUP.md` - 完整的依赖设置指南
- `ADD_DEPENDENCIES.md` - 详细的添加依赖步骤

