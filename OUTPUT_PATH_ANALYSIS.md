# 输出路径分析

## 项目配置分析

### 项目类型
- **ConfigurationType**: `Application` ✅ (可执行文件项目)
- **TargetName**: `GameServer` (Debug 配置) 或 `GameServerFD` (Full Debug 配置)
- **输出文件**: `GameServer.exe` (Debug) 或 `GameServerFD.exe` (Full Debug)

### 默认输出路径

Visual Studio 项目的默认输出路径通常是：

1. **OutDir** (如果未指定):
   - 默认: `$(SolutionDir)$(Configuration)\` 或 `$(ProjectDir)$(Configuration)\`
   - 对于项目在根目录: `Debug\` 或 `Win32\Debug\`

2. **TargetPath** (最终输出路径):
   - `$(OutDir)$(TargetName)$(TargetExt)`
   - 即: `Debug\GameServer.exe`

### 可能的位置

根据项目配置，`GameServer.exe` 可能在以下位置：

1. `Debug\GameServer.exe` (最常见)
2. `Win32\Debug\GameServer.exe`
3. `Debug\Win32\GameServer.exe`
4. `Release\GameServer.exe` (如果是 Release 配置)
5. `.\GameServer.exe` (项目根目录，如果 OutDir 未设置)

## 工作流改进

已更新工作流以：

1. **明确指定输出路径**：
   ```yaml
   /p:OutDir=Debug\ 
   /p:TargetName=GameServer
   ```

2. **优先搜索目标文件**：
   - 首先查找 `GameServer.exe`
   - 然后搜索常见输出目录

3. **显示目录结构**：
   - 如果找不到文件，显示当前目录结构
   - 帮助诊断输出路径问题

4. **从构建日志提取路径**：
   - 分析 MSBuild 日志中的输出路径信息
   - 查找 "Output", "Linking", "Target" 等关键字

## 如果仍然找不到输出

### 检查构建日志

1. 下载 `build-log` 文件
2. 搜索以下关键字：
   - `GameServer.exe`
   - `OutDir`
   - `OutputDirectory`
   - `Linking`
   - `Target`

### 检查 PropertySheets

PropertySheets 可能定义了自定义输出路径：
- `GeneralSettings.props`
- `CrypticApplication.props`
- `LinkerOptimizations.props`

### 本地测试

在本地 Visual Studio 中：
1. 打开项目
2. 编译
3. 查看输出窗口中的路径
4. 或在项目属性中查看 "输出目录"

## 下一步

1. **查看新的构建日志**：检查是否找到了输出路径信息
2. **检查目录结构**：工作流现在会显示当前目录结构
3. **验证输出路径**：确认 GameServer.exe 的实际位置

