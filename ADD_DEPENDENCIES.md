# 如何添加依赖到仓库

## ⚠️ 重要提示

### 1. Git 不能跟踪仓库外的文件！

**不能使用 `git add ../Cryptic/CrossRoads`**

Git 不允许跟踪仓库根目录之外的文件或目录。如果尝试这样做，会看到错误：
```
fatal: ../Cryptic/CrossRoads: '../Cryptic/CrossRoads' is outside repository
```

### 2. 必须在正确的目录下执行

**必须在 `wd02` 目录下执行 Git 命令，不是在 `wd1` 目录！**

## ✅ 正确的操作步骤

### 方法 1: 使用自动化脚本（推荐）

```powershell
cd I:\wd1\wd02

# 1. 复制依赖到仓库内
.\setup_dependencies_correct.ps1

# 2. 修复项目文件路径（从 ..\ 改为仓库内路径）
.\fix_project_paths.ps1

# 3. 添加依赖到 Git
git add CrossRoads Core libs

# 4. 提交
git commit -m "Add dependencies to repository"
git push
```

### 方法 2: 手动操作

#### 1. 切换到 wd02 目录

```bash
cd /i/wd1/wd02
# 或者
cd I:\wd1\wd02
```

### 2. 验证是 Git 仓库

```bash
git status
```

如果显示 "not a git repository"，说明在错误的目录。

### 3. 安装 Git LFS（如果还没安装）

```bash
git lfs install
```

### 4. 配置跟踪大文件

```bash
git lfs track "*.dll"
git lfs track "*.lib"
git lfs track "*.pdb"
git lfs track "*.exe"
git lfs track "*.obj"
```

### 5. 添加 .gitattributes

```bash
git add .gitattributes
```

### 6. 添加依赖

**重要**：依赖必须已经在仓库内（通过步骤 3 复制），不能使用 `../` 路径！

```bash
# 添加 CrossRoads（现在在仓库内）
git add CrossRoads

# 添加 Core（现在在仓库内）
git add Core

# 添加 libs（现在在仓库内）
git add libs
```

### 7. 提交

```bash
git commit -m "Add dependencies with Git LFS"
```

### 8. 推送

```bash
git push
```

## 完整命令序列（复制粘贴）

```bash
# 切换到正确的目录
cd /i/wd1/wd02

# 验证是 Git 仓库
git status

# 安装 Git LFS
git lfs install

# 配置跟踪
git lfs track "*.dll"
git lfs track "*.lib"
git lfs track "*.pdb"
git lfs track "*.exe"

# 添加配置
git add .gitattributes

# 添加依赖
# 注意：现在依赖已经在仓库内，使用相对路径
git add CrossRoads
git add Core
git add libs
git add .gitattributes  # 如果使用了 Git LFS

# 提交
git commit -m "Add dependencies with Git LFS"

# 推送
git push
```

## 常见错误

### 错误 1: "not a git repository"

**原因**：在错误的目录下执行命令

**解决**：确保在 `wd02` 目录下

```bash
cd /i/wd1/wd02
git status  # 验证
```

### 错误 2: 文件太大

**原因**：单个文件超过 100MB

**解决**：使用 Git LFS（如上）

### 错误 3: 找不到依赖目录

**原因**：依赖不在预期位置

**解决**：检查依赖位置

```bash
ls -la /i/wd1/Cryptic/CrossRoads
ls -la /i/wd1/Cryptic/Core
ls -la /i/wd1/libs
```

## 验证

添加依赖后：

1. **检查 Git 状态**：
   ```bash
   git status
   ```

2. **查看文件大小**：
   ```bash
   git lfs ls-files
   ```

3. **触发构建**：
   - 访问：https://github.com/yanlongyang806-cyber/wd02/actions
   - 点击 "Run workflow"

## 注意事项

- ✅ 必须在 `wd02` 目录下执行
- ✅ 使用 Git LFS 处理大文件
- ✅ 检查依赖是否存在
- ❌ 不要在 `wd1` 目录下执行
- ❌ 不要忘记添加 .gitattributes

