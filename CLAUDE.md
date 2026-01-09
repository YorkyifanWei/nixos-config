# NixOS 配置项目 AI 交互指南

## 项目概述

这是一个基于 NixOS-WSL 的个人配置管理项目，使用 Flakes 和 Home Manager 进行声明式配置管理。

- 系统: NixOS 25.05 (WSL 环境)
- 主机名: wsl
- 配置管理: Flakes
- 用户管理: Home Manager
- 默认用户: yorkwei
- 默认 shell: Nushell
- 默认编辑器: Helix

## 关键目录结构

- `hosts/` - 主机特定配置
  - `wsl/` - WSL 系统配置
- `modules/` - 可复用的系统模块
  - `nix/` - Nix 设置 (flakes, 镜像, 存储优化)
  - `wsl/` - WSL 特定设置
- `home/` - Home Manager 配置
  - `default.nix` - 主入口: 用户账户 + Home Manager 配置
  - `shell/` - Shell 相关配置 (nushell, starship, 环境变量)
  - `fonts/` - 字体配置
  - `programs/` - 程序配置

## 技术栈与核心约定

### NixOS 配置管理
- 使用 Flakes 进行声明式配置管理
- 使用 Home Manager 管理用户级配置
- 配置文件使用目录级软链接，修改后无需重新构建

### 包管理原则
- **系统包**: 放在 `hosts/wsl/default.nix` 的 `environment.systemPackages`
- **用户包**: 按类别分散在 `home/` 各子模块的 `home.packages`
  - Shell 相关: `home/shell/default.nix`
  - 程序相关: `home/programs/default.nix`
  - 字体: `home/fonts/default.nix`

### 配置文件组织
- 优先使用 `home.packages` 安装软件
- 使用 `home.sessionVariables` 设置环境变量 (在 `home/shell/common.nix`)
- 使用 `xdg.configFile` 链接配置文件
- 配置文件直接存储在 `home/` 目录下的相应子目录中
- 使用 `config.lib.file.mkOutOfStoreSymlink` 创建目录级软链接
- **不使用** `programs.<program>` 模块管理配置

## 代码风格与命名约定

### Nix 语言约定
- 使用 2 空格缩进
- 列表项按字母顺序排列 (软件包列表)
- 注释使用中文
- 配置项之间添加空行分隔

### Git 提交规范

**格式要求:**
```
简短的标题总结(中文)

主要变更:
1. 具体变更内容1
2. 具体变更内容2
3. 具体变更内容3
```

**注意事项:**
- 不添加 "Co-Authored-By" 或任何 AI 相关信息
- 不添加生成工具标识
- 使用中文编写
- 标题简洁明了，使用祈使句
- 正文使用有序列表形式列出主要变更
- 每个变更项具体明确

## 常用命令

在执行以下操作前，请确认当前在项目根目录：

```bash
# 应用配置
just switch

# 详细调试模式
just switch-verbose

# 仅构建
just build

# 测试模式
just test

# 更新所有依赖
just update

# 更新特定依赖
just update-input nixpkgs

# 清理存储空间
just clean

# 搜索包
just search <包名>

# 查看所有可用命令
just --list
```

## 工作流程与行为规范

### 日常修改配置文件
1. 修改配置文件 (软链接方式)
2. 保存后立即生效，无需重新构建

### 修改软件包或首次部署
1. 修改 Nix 配置文件
2. 测试构建: `just build` 或 `sudo nixos-rebuild build --flake .#wsl`
3. 应用配置: `just switch` 或 `sudo nixos-rebuild switch --flake .#wsl`；可以运行 `just switch-verbose` 在应用配置时显示详细调试信息

### 调试与排错
- 遇到配置错误时，使用 `just switch-verbose` 查看详细错误信息
- 不确定某个配置或命令是否正确时，使用 `/nix` 技能

### 添加新软件
1. 确定是系统包还是用户包
2. 在对应的 Nix 配置文件中添加软件包
3. 如需配置文件，在 `home/programs/` 下创建对应目录并设置软链接

## 环境变量管理策略

项目采用 **XDG 规范** 管理开发工具的数据目录，避免在家目录生成大量隐藏文件夹。并且采用双重设置机制来保证兼容性。

- Home Manager (`home/shell/common.nix`): 使用 `home.sessionVariables` 设置系统级环境变量
- Nushell (`home/shell/nushell/env.nu`): 在 Nushell 启动时设置环境变量

## 特殊注意事项

### 重要规则
- **所有 NixOS 相关的操作必须使用 /nix 技能**来确保符合最佳实践
- **所有与 AI 的交互必须使用中文** (代码注释、变量命名说明、文档和说明、问题和回答)
- WSL 环境，某些桌面环境相关模块不适用
- 已配置清华镜像源加速下载
- 已启用 `nix-ld`，支持运行非 NixOS 二进制文件

### 常见问题
- 首次部署: 需要先启用 Flakes 功能
  1. 复制 `configuration.nix` 到 `/etc/nixos/configuration.nix`
  2. 运行 `sudo nixos-rebuild switch` 启用 Flakes
  3. 运行 `sudo nixos-rebuild switch --flake .#wsl` 部署 Flakes 配置
- 配置文件修改后立即生效 (软链接方式)
- 软件包修改需要重新构建系统

## 存储管理

项目已配置自动优化和垃圾回收:
- 每周自动清理 7 天前的历史版本
- 自动优化 Nix store，删除重复文件

手动清理:
```bash
# 删除 7 天前的历史 generation
just clean-history
# 清理未引用的软件包
just collect-garbage
# 清理重复文件
just optimise

# 或使用 clean 应用上面所有清理
just clean
```

## 扩展阅读

- 项目概述: 见 @README.md

在涉及项目概述的任务前，请先阅读对应文档。
