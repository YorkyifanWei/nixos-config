# NixOS 配置项目

## ⚠️ 重要说明

### 1. 语言要求
**所有与 AI (Claude, ChatGPT 等) 的交互必须使用中文。**

包括但不限于:
- 代码注释
- 变量命名说明
- 文档和说明
- 问题和回答

### 2. 🎯 强制要求: 使用 /nix 技能
**所有 NixOS 相关的操作必须使用 /nix 技能来确保符合最佳实践!**

/nix 技能提供:
- ✅ NixOS 社区的最新最佳实践
- ✅ Flakes 配置的标准模式
- ✅ 正确的命令语法和用法
- ✅ 模块化组织结构
- ✅ Home Manager 配置规范

**何时使用 /nix:**
- 任何涉及 NixOS 配置的修改
- 添加或删除软件包
- 修改系统配置
- 编写 Nix 模块
- 调试 Nix 相关问题
- 不确定某个配置或命令是否正确时

**如何使用:**
```
使用 /nix
```

### 3. Git Commit 信息规范

**格式要求:**

```
简短的标题总结(中文)

主要变更:
1. 具体变更内容1
2. 具体变更内容2
3. 具体变更内容3
```

**注意事项:**
- ❌ 不添加 "Co-Authored-By" 或任何 AI 相关信息
- ❌ 不添加生成工具标识
- ✅ 使用中文编写
- ✅ 标题简洁明了,使用祈使句
- ✅ 正文使用**有序列表**形式列出主要变更
- ✅ 每个变更项具体明确

## 项目概述

这是一个基于 NixOS-WSL 的个人配置管理项目,使用 flakes 和 Home Manager 进行声明式配置管理。

### 系统信息
- **系统**: NixOS 25.05 (WSL 环境)
- **主机名**: wsl
- **配置管理**: Flakes
- **用户管理**: Home Manager
- **默认用户**: yorkwei
- **默认 shell**: Nushell
- **默认编辑器**: Helix
- **包管理**: 声明式,使用清华镜像加速

### ⚠️ Flakes 首次部署说明

**重要概念**: 首次进入全新的 NixOS 系统时，**Flakes 功能尚未启用**，系统不会读取 `flake.nix` 文件！

#### 首次部署流程

1. **启用 Flakes** - 使用 [configuration.nix](configuration.nix) 启用 Flakes 功能
   ```bash
   sudo cp configuration.nix /etc/nixos/configuration.nix
   sudo nixos-rebuild switch
   ```

2. **部署 Flakes 配置** - 现在可以使用 `flake.nix` 了
   ```bash
   sudo nixos-rebuild switch --flake .#wsl
   ```

详细说明请参考 [DEPLOYMENT.md](DEPLOYMENT.md)。

## 项目结构

```
.
├── flake.nix              # Flake 入口,定义输入和输出
├── flake.lock             # 锁文件,确保可重现构建
├── CLAUDE.md              # 本文件,AI 交互说明
├── README.md              # 项目文档
├── DEPLOYMENT.md          # 部署指南
│
├── hosts/                 # 主机特定配置
│   └── wsl/
│       └── default.nix    # WSL 系统配置
│
├── modules/               # 可复用的系统模块
│   ├── nix/
│   │   └── default.nix    # Nix 设置(flakes, 镜像, 存储优化)
│   └── wsl/
│       └── default.nix    # WSL 特定设置
│
└── home/                  # Home Manager 配置
    ├── default.nix        # 主入口: 用户账户 + Home Manager 配置
    ├── shell/             # Shell 相关配置
    │   ├── default.nix    # Shell 模块入口 + shell 软件包声明
    │   ├── common.nix     # 通用环境变量设置 (sessionVariables)
    │   ├── nushell/       # Nushell 配置
    │   │   ├── default.nix    # Nushell 配置文件链接
    │   │   ├── config.nu      # Nushell 主配置文件
    │   │   └── env.nu         # Nushell 环境变量配置
    │   └── starship/       # Starship Prompt 配置
    │       ├── default.nix    # Starship 配置文件链接
    │       └── starship.toml  # Starship 配置文件
    ├── fonts/             # 字体配置
    │   └── default.nix    # 字体包 + Fontconfig 配置
    └── programs/          # 程序配置
        ├── default.nix    # Programs 模块入口 + 所有程序软件包声明
        ├── helix/         # Helix 编辑器配置
        │   └── config.toml
        ├── lazygit/       # Lazygit 配置
        │   └── config.yml
        ├── yazi/          # Yazi 文件管理器配置
        │   ├── yazi.toml
        │   ├── keymap.toml
        │   ├── theme.toml
        │   └── init.lua
        └── zellij/        # Zellij 终端复用器配置
            └── config.kdl
```

## 配置原则

### 1. 系统包 vs 用户包

**系统包** (`hosts/wsl/default.nix` → `environment.systemPackages`):
- 所有用户都可能需要的工具
- 系统级工具和服务

**用户包** (分散在 `home/` 各子模块的 `home.packages`):
- Shell 相关: `home/shell/default.nix` (nushell, starship)
- 程序相关: `home/programs/default.nix` (helix, lazygit, yazi, zellij, claude-code 等)
- 字体: `home/fonts/default.nix` (nerd-fonts, 中文字体)

### 2. Home Manager 使用原则

**Home Manager 配置文件组织:**
- ✅ 使用 `home.packages` 在各子模块中安装相关软件
- ✅ 使用 `home.sessionVariables` 设置环境变量(在 `home/shell/common.nix`)
- ✅ 使用 `xdg.configFile` 链接配置文件(在 `home/shell/*/default.nix` 和 `home/programs/*/default.nix`)
- ✅ 配置文件直接存储在 `home/` 目录下的相应子目录中
- ✅ **使用软链接**: 通过 `config.lib.file.mkOutOfStoreSymlink` 创建目录级软链接，修改配置后无需重新构建即可立即生效
- ❌ 不使用 `programs.<program>` 模块管理配置

**软链接的优势:**
- 🚀 **即时生效**: 修改配置文件后无需运行 `sudo nixos-rebuild switch`
- ⚡ **加速调试**: 频繁修改配置(如编辑器、Shell)时不再需要等待构建
- 📁 **统一管理**: 仍通过 Nix 仓库管理所有配置文件
- 🔄 **目录级软链接**: 添加新配置文件无需修改 Nix 配置

### 3. 模块化组织

- **modules/**: 跨主机可复用的系统配置
  - `modules/nix/`: Nix 包管理器设置 (flakes, 镜像, 自动优化, 垃圾回收)
  - `modules/wsl/`: WSL 特定设置
- **hosts/**: 主机特定配置
- **home/**: Home Manager 配置,包含用户账户和所有用户级配置
  - **home/shell/**: Shell 相关配置(nushell, starship)
  - **home/programs/**: 程序配置(helix, lazygit, yazi, zellij)
  - **home/fonts/**: 字体配置(nerd-fonts, 中文字体)

### 4. 配置流程

**日常修改配置文件（软链接方式）:**
1. 修改配置文件（如 `home/shell/starship/starship.toml`）
2. **立即生效！** 无需重新构建 ✨

**修改软件包或首次部署:**
1. 修改 Nix 配置文件（如 `home/shell/default.nix`）
2. 测试构建: `sudo nixos-rebuild build --flake .#wsl`
3. 应用配置: `sudo nixos-rebuild switch --flake .#wsl`

## 常用命令

⚠️ **重要**: 以下命令必须在 **NixOS-WSL 环境**中执行!

```bash
# 重建系统并应用配置(包含 Home Manager)
# ⚠️ 只在修改软件包或首次部署时需要
sudo nixos-rebuild switch --flake .#wsl

# 仅测试构建
sudo nixos-rebuild build --flake .#wsl

# 测试模式(不添加到引导加载程序)
sudo nixos-rebuild test --flake .#wsl

# 查看详细错误信息(调试用)
sudo nixos-rebuild switch --flake .#wsl --show-trace -L -v

# 更新所有 flake 输入
nix flake update

# 更新特定输入
nix flake update nixpkgs

# 查看 flake 输出信息
nix flake show

# 验证 flake
nix flake check

# 查看系统代数
sudo nixos-rebuild list-generations

# 回滚到上一版本
sudo nixos-rebuild switch --rollback
```

## 实用技巧

### 1. 配置文件即时生效 ✨

**重要**: 本项目所有配置文件使用目录级软链接，修改后无需重新构建即可立即生效！

#### 使用方法

```bash
# 修改任何配置文件，例如:
vim home/shell/starship/starship.toml
vim home/programs/helix/config.toml

# 保存后立即生效！无需运行 nixos-rebuild ✨
```

#### 原理

使用 `config.lib.file.mkOutOfStoreSymlink` 创建指向配置**目录**的软链接:
```nix
# 整个目录软链接
xdg.configFile."starship".source =
  config.lib.file.mkOutOfStoreSymlink "/home/yorkwei/nixos-config/home/shell/starship";

# 效果: ~/.config/starship -> ~/nixos-config/home/shell/starship/
```

这样该目录下的所有文件都会被软链接，添加新文件无需修改 Nix 配置！

#### 适用场景

✅ **配置文件修改** - 立即生效:
- Shell 配置 (nushell, starship)
- 编辑器配置 (helix)
- 工具配置 (lazygit, yazi, zellij)

❌ **需要重建的情况**:
- 添加/删除软件包
- 修改 Nix 配置结构
- 首次部署

### 2. 调试配置错误

部署配置时遇到错误,添加以下参数获取详细错误信息:

```bash
sudo nixos-rebuild switch --flake .#wsl --show-trace --print-build-logs --verbose

# 更简洁的版本
sudo nixos-rebuild switch --flake .#wsl --show-trace -L -v
```

### 3. 使用 Git 管理配置

NixOS 配置文件是纯文本,可以使用 Git 管理,方便回滚和多机同步。

**方法一: 使用软链接**
```bash
# 备份原配置
sudo mv /etc/nixos /etc/nixos.bak

# 创建软链接到你的配置目录
sudo ln -s ~/nixos-config/ /etc/nixos
```

**方法二: 直接指定路径**
```bash
# 备份原配置
sudo mv /etc/nixos /etc/nixos.bak

# 进入配置目录
cd ~/nixos-config

# 部署时直接指定配置路径
sudo nixos-rebuild switch --flake .#wsl
```

**通过 Git 回滚配置**
```bash
cd ~/nixos-config
# 回滚到上一个 commit
git checkout HEAD^1
# 部署（如果需要）
sudo nixos-rebuild switch --flake .#wsl
```

### 4. 查看与清理历史数据

**查看所有历史版本:**
```bash
nix profile history --profile /nix/var/nix/profiles/system
```

**清理历史版本释放存储空间:**
```bash
# 清理 7 天之前的所有历史版本
sudo nix profile wipe-history --older-than 7d --profile /nix/var/nix/profiles/system

# 删除所有未使用的包
sudo nix-collect-garbage --delete-old

# 删除 home-manager 的历史版本和包(以当前用户身份)
nix-collect-garbage --delete-old
```

**手动优化存储:**
```bash
# 优化 Nix store,删除重复文件
nix-store --optimise
```

### 5. 存储空间优化

本项目已配置以下优化设置 (在 `modules/nix/default.nix` 中):

- ✅ **自动优化存储**: `nix.settings.auto-optimise-store = true`
- ✅ **自动垃圾回收**: 每周清理 7 天前的历史版本

这些配置可以显著减少磁盘占用。

### 6. 查询包依赖关系

查询为什么某个包被安装,谁依赖了它:

```bash
# 进入带有 nix-tree 和 ripgrep 的 shell
nix shell nixpkgs#nix-tree nixpkgs#ripgrep

# 查看依赖关系
nix-store --gc --print-roots | rg -v '/proc/' | rg -Po '(?<= -> ).*' | xargs -o nix-tree

# 在 nix-tree 中输入 w 查看谁依赖了某个包(why depends)
```

## 添加新软件

### 添加系统包
编辑 `hosts/wsl/default.nix`:
```nix
environment.systemPackages = with pkgs; [
  vim
  wget
  你的新包  # 在这里添加
];
```

### 添加用户软件包

**Shell 相关工具**:
编辑 `home/shell/default.nix`

**程序相关工具**:
编辑 `home/programs/default.nix`

**字体**:
编辑 `home/fonts/default.nix`

### 添加程序配置文件

如果程序需要配置文件,在 `home/programs/` 下创建对应目录:

1. 创建目录: `home/programs/你的程序/`
2. 添加配置文件到该目录
3. 创建 `default.nix` 设置目录软链接:
```nix
{ config, pkgs, ... }:
let
  configPath = "${config.home.homeDirectory}/nixos-config/home/programs/你的程序";
in
{
  xdg.configFile."你的程序".source =
    config.lib.file.mkOutOfStoreSymlink configPath;
}
```
4. 在 `home/programs/default.nix` 的 `imports` 中添加该目录

## 配置文件位置说明

### 环境变量配置
- **Home Manager 环境变量**: `home/shell/common.nix` (使用 `home.sessionVariables`)
- **Nushell 环境变量**: `home/shell/nushell/env.nu` (在 Nushell 启动时设置)

### Shell 配置
- **Nushell 主配置**: `home/shell/nushell/config.nu`
- **Starship 配置**: `home/shell/starship/starship.toml`

### 程序配置
- **Helix**: `home/programs/helix/`
- **Lazygit**: `home/programs/lazygit/`
- **Yazi**: `home/programs/yazi/`
- **Zellij**: `home/programs/zellij/`

### 字体配置
- **字体包声明**: `home/fonts/default.nix`

## 开发工具配置

### 环境变量管理策略

本项目采用 **XDG 规范** 来管理开发工具的数据目录,避免在家目录生成大量隐藏文件夹。

#### 双重设置机制

**Home Manager** (`home/shell/common.nix`):
- 使用 `home.sessionVariables` 设置系统级环境变量
- 确保所有程序(包括 GUI 应用)都能看到这些变量
- 使用 `$XDG_DATA_HOME` 等变量构造路径

**Nushell** (`home/shell/nushell/env.nu`):
- 在 Nushell 启动时设置环境变量
- 使用 Nushell 语法的路径拼接: `($env.XDG_DATA_HOME | path join "cargo")`
- 确保 Nushell 及其子进程使用正确的目录

### 已配置的开发工具

- **Rust**: `CARGO_HOME`, `RUSTUP_HOME` → `$XDG_DATA_HOME/cargo`, `$XDG_DATA_HOME/rustup`
- **Go**: `GOPATH`, `GOMODCACHE` → `$XDG_DATA_HOME/go`
- **Node.js (fnm)**: `FNM_DIR` → `$XDG_DATA_HOME/fnm`
- **Python (uv)**: `UV_CACHE_DIR`, `UV_PYTHON_INSTALL_DIR`, `UV_TOOL_DIR`
- **Java (Gradle)**: `GRADLE_USER_HOME` → `$XDG_DATA_HOME/gradle`

### 添加新的开发工具

当添加需要自定义目录的开发工具时,遵循以下模式:

1. **在 `home/shell/common.nix`** 的 `home.sessionVariables` 中设置环境变量
2. **在 `home/shell/nushell/env.nu`** 中设置 Nushell 环境变量
3. **在 `home/shell/nushell/config.nu`** 中添加 PATH (如果需要)

## 特殊注意事项

1. **WSL 环境**: 这是 WSL 配置,某些桌面环境相关模块不适用
2. **中文支持**: 所有 AI 交互和文档使用中文
3. **清华镜像**: 已配置清华镜像源加速下载
4. **Flakes 必需**: git 作为系统包安装,用于 flakes 功能
5. **软链接配置**: 所有配置文件使用目录级软链接,修改即生效
6. **VSCode Remote 支持**: 已启用 `nix-ld`,支持运行非 NixOS 二进制文件

## 资源

### 官方文档
- [NixOS 手册](https://nixos.org/manual/nixos/stable/)
- [Home Manager 手册](https://nix-community.github.io/home-manager/)
- [NixOS & Flakes 指南](https://nixos-and-flakes.thiscute.world/zh-cn/)
- [NixOS-WSL 仓库](https://github.com/nix-community/NixOS-WSL)
- [NixOS 包搜索](https://search.nixos.org/packages)

### 社区资源
- [NixOS Wiki](https://nixos.wiki/)
- [Home Manager Options](https://mynixos.com/home-manager)
- [Nixpkgs Options](https://search.nixos.org/options)
